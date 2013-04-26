-module(bubble).
-compile(export_all).

bubble_sort(L) when length(L) =< 1 ->
    L;
bubble_sort(L) ->
    SL = bubble_sort_p(L),
    bubble_sort(lists:sublist(SL,1,length(SL)-1)) ++ [lists:last(SL)].

bubble_sort_p([])  ->
    [];
bubble_sort_p([F]) ->
    [F];
bubble_sort_p([F,G|T]) when F > G ->
    [G|bubble_sort_p([F|T])];
bubble_sort_p([F,G|T]) ->
    [F|bubble_sort_p([G|T])].
