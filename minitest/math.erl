-module(math).
-compile(export_all).

factorial(0) ->   1;
factorial(X) when X > 0 -> X * factorial(X-1).

factorial_tc(N) ->
	factorial_tc(N, 1).
factorial_tc(N, Acc) when N > 1 ->	
	factorial_tc(N-1, Acc*N);
factorial_tc(1, Acc) ->
	Acc.
