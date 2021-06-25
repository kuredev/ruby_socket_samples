require "socket"

server = TCPServer.open(12345)
socket = server.accept
buf = socket.gets
pp buf

socket.close
server.close
