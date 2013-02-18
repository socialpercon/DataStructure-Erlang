-module(test_rotate).
-export([test/0]).

test() ->
 assert(left_rotate([a,b,c]), [b,c,a]).

assert(X, X) -> true.

left_rotate([]) -> [];
left_rotate([H|T]) -> T ++ [H].
