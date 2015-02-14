-module(client).
-export([start/0]).

start() ->
	{ok, Socket} = gen_tcp:connect({127,0,0,1}, 8080, [binary, {active,false}]),
	spawn(fun() -> socket_receive(Socket) end),
	Username=io:get_line("username: "),
	gen_tcp:send(Socket, Username),
	wait_input(Socket).


wait_input(Socket) ->
	Message= io:get_line(">"),
	gen_tcp:send(Socket, term_to_binary({broadcast, Message})),
	wait_input(Socket).

socket_receive(Socket) ->
	case gen_tcp:recv(Socket, 0) of
		{ok, Data} ->
			case binary_to_term(Data) of
				{message, Username, Message} ->
					io:format("~s: ~s~n", [Username, Message])
			end,
			socket_receive(Socket);
		{error, Reason} ->
			io:format("Socket Closed: ~s~n", [Reason])
	end.
	
