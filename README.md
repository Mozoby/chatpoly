# chatpoly

Usage is rudimentary right now, it requires use of multiple erlang shells.

Open two terminals, one for client, another for the server. Change the working directory of both to the root directory of chatpoly.

Set up the Server:
    
    cd ./server
    erl
    Erlang/OTP 17 [erts-6.2] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]
    
    Eshell V6.2  (abort with ^G)
    1> c(server).
    server.erl:77: Warning: variable 'Username' is unused
    {ok,server}
    2> server:start().

The Server is now Accepting Users.

Now set up a Client, in the client terminal:

    cd ./client/erlang
    erl
    Erlang/OTP 17 [erts-6.2] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]
    
    Eshell V6.2  (abort with ^G)
    1> c(client).
    {ok,client}
    2> client:start().
    username:

Type in a username and you are ready to go!

    username: Bryan
    >hey there!
    Bryan: hey there!
    
    >



