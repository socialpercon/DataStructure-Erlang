%%% File    : usr.erl
%%% Description : API and Mnesia code for cellphone user db

-module(usr).
-export([create_tables/0, ensure_loaded/0]).
-export([add_usr/3, delete_usr/1, set_service/3, set_status/2, 
	 delete_disabled/0, lookup_id/1]).
-export([lookup_msisdn/1, service_flag/2, excute_table/0, reset_tables/0, example_tables/0]).
-import(lists, [foreach/2]).
-include("datastore.hrl").
-include("usr.hrl").


-define(TABLE_INFO, [{disc_copies, [node()]},
                                       {index, [name, version]},
                                       {attributes, record_info(fields, package_info)},
                                       {storage_properties, [{ets, [compressed]}, {dets, [{auto_save, 5000}]}
                                       ]}]).

%% Mnesia API


%% @doc make mnesia table
%% if table is exist on disk, just load table.
%% @spec excute_table() -> ok

-spec(excute_table() -> ok).
excute_table() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    %mnesia:delete_table(package_info),
	case mnesia:create_table(package_info, ?TABLE_INFO) of
		{atomic, ok} ->
			ok;
		{aborted, Reason} ->
			Reason
	end.
	
	%case mnesia:transaction(F) of
    %    {atomic, ok} -> 
    %    	mnesia:stop(),
    %        ok;
    %    {atomic, What} ->
    %    	What;
    %    {aborted, Reason} ->
    %        Reason
	%end.
    %case mnesia:transaction(fun mnesia:create_table/2, [package_info, ?TABLE_INFO]) of
    %    {atomic, What} ->
    %    	What;
    %    {aborted, Reason} ->
    %        Reason
    %end.

reset_tables() ->
    F = fun() ->
		foreach(fun mnesia:write/1, example_tables())
	end,
    mnesia:transaction(F).

example_tables() ->
    Rec = #package_info{id=1, name=mypackage, version=snapshot, time=20130322, hashkey=123124},
    Fun = fun() -> mnesia:write(Rec) end,
    {atomic, Res}= mnesia:transaction(Fun),
    Res.
    %mnesia:write(#package_info{id=1, name=mypackage, version=snapshot, time=20130322, hashkey=123124}).

create_tables() ->

    mnesia:create_table(usr, [{disc_copies, [node()]}, {ram_copies, nodes()},
			      {type, set}, {attributes,record_info(fields, usr)},
			      {index, [id]}]).

ensure_loaded() ->
    ok = mnesia:wait_for_tables([usr], 60000).

add_usr(PhoneNo, CustId, Plan) when Plan==prepay; Plan==postpay ->
    Rec = #usr{msisdn = PhoneNo,
	       id = CustId,
	       plan = Plan},
    Fun = fun() -> mnesia:write(Rec) end,
    {atomic, Res}= mnesia:transaction(Fun),
    Res.

delete_usr(CustId) ->
    F = fun() -> case mnesia:index_read(usr, CustId, id) of
		     [] -> {error, instance};
		     [Usr] -> mnesia:delete({usr, Usr#usr.msisdn})
		 end
	end,
    {atomic,Result} = mnesia:transaction(F),
    Result.


set_service(CustId, Service, Flag) when Flag==true; Flag==false ->
    F = fun() ->
		case mnesia:index_read(usr, CustId, id) of
		    [] -> {error, instance};
		    [Usr] ->
			Services = lists:delete(Service, Usr#usr.services),
			NewServices = case Flag of
					  true -> [Service|Services];
					  false -> Services
				      end,
			mnesia:write(Usr#usr{services=NewServices})
		end
	end,
    {atomic, Result} = mnesia:transaction(F),
    Result.

set_status(CustId, Status) when Status==enabled; Status==disabled->
    F = fun() ->
		case mnesia:index_read(usr, CustId, id) of
		    [] -> {error, instance};
		    [Usr] -> mnesia:write(Usr#usr{status=Status})
		end
	end,
    {atomic, Result} = mnesia:transaction(F),
    Result.

lookup_id(CustId) ->
    case mnesia:dirty_index_read(usr, CustId, id) of
	[Usr] -> {ok, Usr};
	[] -> {error, instance}
    end.
%% Service API
lookup_msisdn(PhoneNo) ->
    case mnesia:dirty_read({usr, PhoneNo}) of
	[Usr] -> {ok, Usr};
	[] -> {error, instance}
    end.
service_flag(PhoneNo, Service) ->
    case lookup_msisdn(PhoneNo) of
	{ok,#usr{services=Services, status=enabled}} ->
	    lists:member(Service, Services);
	{ok, #usr{status=disabled}} ->
	    {error, disabled};
	{error, Reason} ->
	    {error, Reason}
    end.

delete_disabled() ->
    F = fun() ->
		FoldFun = fun(#usr{status=disabled, msisdn = PhoneNo},_) ->
				  mnesia:delete({usr, PhoneNo});
			     (_,_) ->
				  ok
			  end,
		mnesia:foldl(FoldFun, ok, usr)
	end,
    {atomic, ok} = mnesia:transaction(F), ok.


 
