-module(websocket).
-export([start/0]).

start() ->
	Stuff = io:get_line(),
	io:format("~p", Stuff),
	start().