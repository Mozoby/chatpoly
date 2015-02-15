-module(websocket).

start() ->
	Stuff = io:get_line(),
	io:format("~p", Stuff),
	start().

start().