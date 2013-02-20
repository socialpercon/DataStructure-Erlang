-module(oddsfoldl).
-compile(export_all).

odds(List) ->
 LoadFun = fun(H,Collect) ->
  case (H rem 2) of
   1 -> [H]++Collect;
   _ -> Collect
  end
 end,
 lists:foldr(LoadFun,[],List).

