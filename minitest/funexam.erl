-module(funexam).
-export([odds/1]).

odds([H|T]) ->
 case (H rem 2) of
  1 -> H;
  0 -> odds(T)
 end.
