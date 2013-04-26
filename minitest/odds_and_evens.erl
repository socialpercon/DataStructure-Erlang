-module(odds_and_evens).
-export([odds_and_evens/1]).

odds_and_evens(L) ->
	Odds = [X || X <- L, (X rem 2) =:= 1],
	Evens = [X || X <- L, (X rem 2) =:= 0],
	{Odds, Evens}.
