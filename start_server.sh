#!/bin/sh
export HOME=/home/azureuser
# exec ./chatpoly/client/erlang/websocket.erl
erl -compile ./server/server.erl

erl -noshell -s server start -s init stop &
./lib/websocketd_linux64 --port 8080 ./websocket_courier.py