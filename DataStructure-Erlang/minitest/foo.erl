-module(foo).
-export([foo/3]).

foo(X,Y,Z) when X=:=Y+Z ->
 Y+Z.
