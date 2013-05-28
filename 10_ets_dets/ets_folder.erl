-module(ets_folder).
%-behaviour(gen_server).

%% External exports
-export([start_link/0]).

%% gen_server callbacks
-export([init/1]).

-include("ets_folder.hrl").


%% Internal exports
-export([ets_confirm/1,ets_post/2, execute_table/0,ets_search/1,ets_delete/1,folder_search/1,ets_update/2,delete_all/1]).

execute_table() ->
    case ets:file2tab("ets_folder") of
	{ok, Name} ->
	    {ok, Name};
	_ ->
	    ets:new(cfg_info,
		    [ordered_set,
		    named_table,
		    {keypos, ?CFG_INFO_KEY}
		    ]),
	    ets:tab2file(cfg_info, "ets_folder")
    end.

%% init callback for gen_server
init(_Args) ->
    case execute_table() of
	{ok, Name} ->
		ets_folder:ets_post(["a","b","c"],"ho"),
	    {ok, Name};
	{error, Reason} ->
	    {stop, Reason}
    end.

%% start config server
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% Internal Function
ets_confirm(Key) ->
	Confirm = fun(X, [H|T]) ->
				Sum = H ++ [X],
			    Result = case ets:lookup(cfg_info, Sum) of
					        [] ->
					        	[Sum, [H|T]];
					        [{cfg_info, _Key, dir}] ->
					            [Sum, [H|T]];
					        [{cfg_info, _Key, _Value}] ->
					            throw(error)
					    end,
			    Result
			end,
	%List = lists:foldl(fun(X, [H| T]) -> Result = H ++ [X], io:format("~p\r\n", [Result]), [Result, H| T] end, [[]], ["os","PYTHON","B","C","D"]).
    try
    	_Exist=case ets:member(cfg_info, Key) of
					        true ->
					            throw(error);
					        false ->
					        	ok	            
		end,
    	lists:foldl(Confirm, [[]], Key)
    catch
    	throw:error ->
    		error
    end.

ets_post(Key, Value) ->
	case ets_confirm(Key) of
		error ->
			error;
		_List ->
			Confirm = fun(X, [H|T]) ->
						Result = H ++ [X],
						Record = #cfg_info{
							key = Result,
							value = dir
						},
						ets:insert(cfg_info, Record),
					    [Result, H|T]
					end,
			%List = lists:foldl(fun(X, [H| T]) -> Result = H ++ [X], io:format("~p\r\n", [Result]), [Result, H| T] end, [[]], ["os","PYTHON","B","C","D"]).
		    lists:foldl(Confirm, [[]], Key),
		    ets:insert(cfg_info, #cfg_info{key=Key, value=Value}),
		    ets:tab2file(cfg_info, "ets_folder")
	end.

ets_search(Key) ->
	case ets:lookup(cfg_info, Key) of
        [] ->
        	{error, not_found};
        [{cfg_info, Key, dir}] ->
            folder_search(Key);
        [{cfg_info, _Key, Value}] ->
            Value
    end.

ets_delete(Key) ->
	case ets:lookup(cfg_info, Key) of
		[] ->
			{error, not_found};
		[{cfg_info, Key, dir}] ->
			case folder_search(Key) of
				{ok, _File} ->
					{confirm, dir}
			end;
		[{cfg_info, Key, _Value}] ->
			ets:delete(cfg_info, Key),
			PKey = lists:sublist(Key,lists:flatlength(Key)-1),
			folder_search(PKey),
			{ok, del}
	end.

delete_all(Key) ->
	List = ets:match(cfg_info,{cfg_info , Key++'$1', '$2'}),
	Result = [Key++K || [K, _V] <- List],
	F = fun(X, _Sum) -> ets:delete(cfg_info, X) end,
	lists:foldl(F, [], Result),
	folder_search(Key).

folder_search(Key) ->
	List = ets:match(cfg_info,{cfg_info , Key++'$1', '$2'}),
	Result = [{Key++K, V} || [K, V] <- List, V /= dir],
	case Result of
		[] ->
			ets:delete(cfg_info, Key),
			Length = lists:flatlength(Key) - 1,
			PKey = lists:sublist(Key, Length),
			if
				Length > 1 ->
					folder_search(PKey);
				true ->
					{ok, del_parent}
			end;
		File ->
			{ok, File}
	end.

ets_update(Key, Value) ->
	case ets:lookup(cfg_info, Key) of
		[] ->
			{error, not_found};
		[{cfg_info, Key, dir}] ->
			{error, dir};
		[{cfg_info,_K,_V}] ->
			ets:insert(cfg_info, #cfg_info{key = Key, value = Value}),
			{ok, update}
	end.