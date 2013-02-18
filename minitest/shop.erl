-module(shop).
-export([cost/1]).
-export([total/1]).

cost(apples) -> 3;
cost(oranges) -> 5;
cost(milk) -> 7.

total([{What, N}|T]) -> shop:cost(What) * N + total(T);
total([]) -> 0.

