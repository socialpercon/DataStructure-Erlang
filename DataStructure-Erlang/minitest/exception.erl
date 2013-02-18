-module(exception).
-compile(export_all).

 try find(L) of
    {answer, N} when N == 42 -> true;
    _ -> false
 catch
    {notanumber, R} when is_list(R) -> alist;
    {notanumber, R} when is_float(R) -> afloat
    _ -> noidea
 end.
