

data_loop(Socket) ->
    ok = inet:setopts(Socket, [{active, once}]),
    receive
        {tcp, _Socket, Data} ->
            StringData = binary_to_list(Data),
            Line = list_util:stripline(StringData),       % strip \r\n from data
            case Line == StringData of
                true -> 
                    Line ++ data_loop(Socket);
                false ->
                    Line
            end;
        {tcp_closed, _Socket} ->
            ""
    end.
