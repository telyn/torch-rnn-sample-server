local http = require('socket')

HOST="127.0.0.1"
PORT=80
BACKLOG=5

print('starting server')
local server =assert(socket.tcp())
assert(server:bind(HOST, PORT))
server:listen(backlog)

print('started server on http://'..HOST..':'..PORT)

while 1 do
	local client, err = server:accept()
	if client then
		client:send("HTTP/1.0 200 OK\nContent-Type: text/plain\n\nHi\n\n")
	end
	client:close()
end
