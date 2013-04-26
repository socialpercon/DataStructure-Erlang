-module(odds).
-compile(export_all).


odds(L) ->
 odds(L,[]).
odds([H|T],L) ->
 case (H rem 2) of
  1 -> odds(T,[H]++L);
  0 -> odds(T,L)
 end;
odds([],L) ->
 lists:reverse(L).

