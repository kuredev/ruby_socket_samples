require "socket"

srv_addr = ""
socket = TCPSocket.open(srv_addr, 12345)
socket.write("HELLO")
socket.close
