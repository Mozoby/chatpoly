-module(server).
-compile(export_all).

start() ->
	MessageRouterPid = spawn(fun() -> route_messages() end),
	register(message_router, MessageRouterPid),

	ConnectionManagerPid = spawn(fun() -> manage_connections([]) end),
	register(connection_manager, ConnectionManagerPid),

	do_listen().



do_listen() -> 
	{ok, ListenSocket} = gen_tcp:listen(8080, [binary, {active,false}]),
	do_accept(ListenSocket).

do_accept(ListenSocket) ->
	{ok, AcceptSocket} = gen_tcp:accept(ListenSocket),
	io:fwrite("Socket Connected.", []),
	spawn(fun() -> do_authenticate(AcceptSocket) end),
	do_accept(ListenSocket).

do_authenticate(Socket) ->
	case gen_tcp:recv(Socket, 0) of
		{ok, RawUsername} ->
			Username = re:replace(RawUsername, "(^\\s+)|(\\s+$)", "", [global,{return,list}]),
			io:fwrite("User Ready: ~s", [Username]),
			connection_manager ! {connect, Socket, Username},
			do_receive({Socket, Username});
		{error, closed} ->
			ok
	end.

do_receive({Socket, Username}) ->
	case gen_tcp:recv(Socket, 0) of
		{ok, Data} ->
			io:format("~s~n", [Data]),
			message_router ! {ok, Username, Data},
			do_receive({Socket, Username});
		{error, Reason} ->
			io:format("Socket Closed!!! ~nReason=~p~n", [Reason])
	end.

route_messages() ->
	receive
		{ok, Username, Data} ->
			T = binary_to_term(Data),
			io:format("~p~n", [T]),
			case T of
				{broadcast, Message} ->
					connection_manager ! {broadcast, Username, Message};

				{private, MessageData} -> % MessageData => {TargetUsername, MessageText}
					connection_manager ! {private, Username, MessageData}

			end
	end,
	route_messages().

manage_connections(List) ->
	receive
		{connect, Socket, Username} ->
			NewList = [{Socket, Username} | List],
			manage_connections(NewList);

		{broadcast, Username, Message} ->
			send_data(Username, List, Message),
			manage_connections(List)

		% {private, MessageData} ->

	end.

send_data(From, Sockets, Data) ->
	SendData = fun({Socket, Username}) ->
					gen_tcp:send(Socket, term_to_binary({message, From, Data}))
				end,

	lists:foreach(SendData, Sockets).

% send_data(private, Target, [{User, Socket} | Tail], Data) ->
	
