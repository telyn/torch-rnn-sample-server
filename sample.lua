require 'torch'
require 'nn'

require 'LanguageModel'
local socket = require 'socket'

local cmd = torch.CmdLine()
cmd:option('-checkpoint', 'cv/checkpoint_10.t7')
cmd:option('-length', 200)
cmd:option('-start_text', '')
cmd:option('-sample', 1)
cmd:option('-temperature', 1)
cmd:option('-verbose', 0)
cmd:option('-host', "127.0.0.1")
cmd:option('-port', 8080)
local opt = cmd:parse(arg)

print(opt)
local checkpoint = torch.load(opt.checkpoint)
local model = checkpoint.model

print('evaluating model...')

model:evaluate()

print('evaluation complete. starting http server')

print('starting server')
local server =assert(socket.tcp())
assert(server:bind(opt.host, opt.port))
server:listen(backlog)

print('started server on http://'..opt.host..':'..opt.port)

while 1 do
	local client, err = server:accept()
	if client then
	local sample = model:sample(opt)

	client:send('HTTP/1.0 200 OK\nContent-Type: text/plain\n\n')
	client:send(sample)
	client:send('\n\n')
end
client:close()
end

print('server running at http://localhost:1337/')
