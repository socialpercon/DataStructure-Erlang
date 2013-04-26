%% @author Socialpercon

%% @author Socialpercon <socialpercon@gmail.com>
%%   [http://blog.naver.com/sealriel]

%% @copyright gnu
%% @deprecated Please use the module {@link foo} instead.
%% @doc This is a <em>very</em> useful module for studying macros.
%% @reference book
%% more information.
%% @version 0.01

-module(macros1).
-include("person.hrl").
-export([tstFun/2,birthday/1,test1/0]).

-define(Multiple(X,Y),X rem Y == 0).

%% @deprecated module define pratice
%% @spec tstFun(Integer, Integer) -> true | false
tstFun(Z,W) when ?Multiple(Z,W) -> 
    true;
tstFun(Z,W)                     -> 
    false.

%-define(DBG(Str, Args), ok).
-define(DBG(Str, Args), io:format(Str, Args)).

%rr("person.hrl").
%X=#person{name="test", age=20, phone=[010-0000-0000].
%macros1:birthday(X).
% to add age 
birthday(#person{age=Age} = P) ->
    ?DBG("in records1:birthday(~p)~n", [P]),
    P#person{age=Age+1}.

-define(VALUE(Call),io:format("~p = ~p~n",[??Call,Call])).
test1() -> ?VALUE(length([1,2,3])).

