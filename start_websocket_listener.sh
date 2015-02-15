#!/bin/sh
export HOME=/home/azureuser
exec ./chatpoly/client/erlang/websocket.erl
# erl -compile ./chatpoly/client/erlang/websocket.erl
# erl -noshell -s websocket start -s init stop