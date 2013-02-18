-module(fibo).
-compile(export_all).

fibo(0) ->
 0;
fibo(1) ->
 1;
fibo(N) when N > 1 ->
 fibo(N - 2) + fibo(N - 1).

fibo_tc(0) ->
 0;
fibo_tc(1) ->
 1;
fibo_tc(N) when N > 1 ->
 fibo_tc(N, 1, 1, 1).
fibo_tc(N, I, Acc1, Acc2) when (N > 1) and (I < N) ->
 fibo_tc(N, I + 1, Acc2, Acc1 + Acc2);
fibo_tc(N, N, Acc1, _Acc2) ->
 Acc1.
