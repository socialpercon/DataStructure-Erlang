-module([odds_evens]).
-compile(export_all).

odds_evens(L) ->
 odds_evens(L,[],[]),
odds_evens([H|T], Odds, Evens) ->
 case (H rem 2) of
  1 -> odds_evens(T,[H|Odds],Evens);
  0 -> odds_evens(T,Odds,[H|Evens])
 end;

odds_evens([], Odds, Evens) ->
  {Odds, Evens}.
