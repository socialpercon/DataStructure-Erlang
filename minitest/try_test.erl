-module(try_test).
-export([demo1/0,catcher/1]).

demo() ->
	[catcher(I) || I <- [1,2,3,4,5]].
catcher(N) ->
	try generate_exception(N) of
		val -> {N, normal, Val}
	catch
		throw:X -> {N, caught, thrown, X};
