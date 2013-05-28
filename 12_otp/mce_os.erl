-module(mce_os).

-behaviour(gen_server).

%% public API
-export([start_link/0,
         get_conf/1,
         post_conf/2,
         put_conf/2]).

%% gen_server callbacks
-export([init/1, handle_call/3]).


%% Exported Client Functions
%% Operation & Maintenance API


%% DO NOT use exit/1 to stop a gen_server process
%% always exit with {stop, Reason, LoaderST} in standard callbacks,
%% or {stop, Reason, Reply, LoaderST} in handle_call/3

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, ENV, []).

%% Customer Services API

get_conf(Key) ->
    gen_server:call({local, ?MODULE}, {get_conf, Key}).
post_conf(Key, Value) ->
    gen_server:call({local, ?MODULE}, {post_conf, Key, Value}).
put_conf(Key, Value) ->
    gen_server:call({local, ?MODULE}, {put_conf, Key, Value}).

%% Callback Functions

init(InitState) ->
  {ok, InitState}.

handle_call({get_env, Key}, _From, State) ->
  Reply = 
  os:getenv(Key),
  {reply, Reply, State};

handle_call({post_env, Key, Value}, _From, State) ->
  Reply = 
  case os:getenv(Key) of
    false ->
      os:putenv(Key, Value);
    Res ->
      {error, exist}
  end,
  {reply, Reply, State};

handle_call({update_env, Key, Value}, _From, State) ->
  Reply = 
  os:putenv(Key, Value),
  {reply, Reply, State}.

