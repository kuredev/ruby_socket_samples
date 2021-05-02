require "socket"

@udp = UDPSocket.open

def send1
  sockaddr = Socket.pack_sockaddr_in(10000, "18.180.200.17")
  @udp.send("HELLO", 0, sockaddr)
end

def send2
  @udp.connect("18.180.200.17", 10000)
  @udp.send("HELLO", 0) # connect が必要みたい
end

def send3
  @udp.send("HELLO", 0, "18.180.200.17", 10000)
end

send3
@udp.close
