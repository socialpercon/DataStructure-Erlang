-module(port_test).
-export([start/0, stop/0]).
-export([double/1,sum/2,gethtml/1]).

start() ->
 spawn(fun() ->
  register(example1, self()),
  process_flag(trap_exit, true),
  Port = open_port({spawn, "python test.py"},[{packet, 4}]),
  loop(Port)
 end).

stop() ->
 example1 ! stop.


%double, sum, gethtml 함수에 대한 인터페이싱 코드가 들어 있다.
double(X) -> 
	call_port({double, X}).
sum(X, Y) -> 
		call_port({sum, X, Y}).
	gethtml(X) ->
 Html = call_port({gethtml, X}),
 io:format("~s", [Html]).
 
call_port(Msg) ->
 example1 ! {call, self(), Msg},
 receive
 {example1, Result} ->
  Result
 end.

loop(Port) ->
 receive
 {call, Caller, Msg} ->
  Port ! {self(), {command, encode(Msg)}},
  receive
  {Port, {data, Data}} ->
   Caller ! {example1, decode(Data)}
  end,
  loop(Port);
 stop ->
  Port ! {self(), close},
  receive
  {Port, closed} ->
   exit(normal)
  end;
 {'EXIT', Port, Reason} ->
  exit({port_terminated, Reason})
 end.

%각 함수 식별자 0,1,2와 함께 Bit syntax로 표현이 되어 있다.
encode({double, X}) ->
 %X라는 변수를 32bit로 팩킹해서 binary데이터로 만든다는 의미이다.
 %이때 기본적으로 Big-endian으로 패킹 된다.
 NewX = <<X:32>>,
 [1, NewX];
encode({sum, X, Y}) ->
 [0, <<X:32, Y:32>>];

%gethtml에는 url 인자가 넘겨지는데, 이는 string이기 때문에 list_to_binary함수로 간단하게
%binary데이터로 변환 할 수 있다
encode({gethtml, X}) ->
 [2, list_to_binary(X)].

%받아온 데이터 사이즈가 4바이트 이면 Int형 변환을 실시하고
%그것보다 크면 string데이터로 간주하고 그대로 반환하는 코드
%string 데이터는 python에서 gethtml에 의해 리턴된 결과
decode(Data) ->
 case size(list_to_binary(Data)) of
  Size when Size == 4 ->
   <<Int:32>> = list_to_binary(Data),
   Int;
  Size when Size > 4 ->
   Data;
  true ->
   io:format("some error occurs!~n")
 end.
