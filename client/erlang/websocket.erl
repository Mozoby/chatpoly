-module(websocket).
-export([start/0]).
-import(io, [get_line/1]).

start() ->
	Stuff = io:get_line("?> "),
	io:format("~w", [Stuff]),
	start().