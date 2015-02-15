#!/usr/bin/env escript
-module(websocket).
-export([start/0, main/1]).

start() ->
	Stuff = io:get_line("?> "),
	io:format("~w", [Stuff]),
	start().

main(_) -> start().