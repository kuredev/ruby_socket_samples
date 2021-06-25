require "socket"

server = TCPServer.open(12345)
socket = server.accept
while buf = socket.gets
  pp buf
end

socket.close
server.close
