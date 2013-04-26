-module(socket_examples).
-compile(export_all).


start_nano_server() ->
 {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4},{reuseaddr, true},{active, true}]),
 accept_loop(Listen).

accept_loop(Listen) ->
 {ok, Socket} = gen_tcp:accept(Listen),
 Process = spawn(fun() -> loop(Socket) end),
 gen_tcp:controlling_process(Socket, Process),
 accept_loop(Listen).

loop(Socket) ->
 receive
  {tcp, Socket, Bin} ->
   io:format("Server received binary = ~p~n" ,[Bin]),
   Str = binary_to_term(Bin),
   io:format("Server (unpacked) ~p~n" , [Str]),
   Reply = Str,
   io:format("Server replying = ~p~n" , [Reply]),
   gen_tcp:send(Socket, term_to_binary(Reply)),
   loop(Socket);
  {tcp_closed, Socket} ->
   io:format("Server socket closed~n" )
 end.

