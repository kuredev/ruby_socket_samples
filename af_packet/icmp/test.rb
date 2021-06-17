# 送信するだけの

require "ipaddr"
require "socket"
require_relative "sock_address_ll"
require_relative "ip_header"
require_relative "icmp_header"

# IP Header から指定する
def socket
  @socket ||= Socket.open(
    Socket::AF_PACKET,
    Socket::SOCK_DGRAM,
    Socket::IPPROTO_ICMP
  )
end

version = 4 # 4bit
header_length = 5 # 4bit
tos = 0 # 1Byte, diffserf も入ってる(6bit)
total_length = 28 # 2Byte
id = 15637 # 2Byte
flags = 0 # 3bit
fragment = 0 # 13bit
time_to_live = 128 # 1Byte
protocol = 1 # 1Byte, ICMP
checksum = 0 # 2Byte
src_addr = "172.31.11.244" # 4Byte, この順でいいのか？
dst_addr = "8.8.8.8" # 4Byte

ip_header = IPHeader.new(
  version: version,
  header_length: header_length,
  tos: tos,
  total_length: total_length,
  id: id,
  flags: flags,
  fragment: fragment,
  time_to_live: time_to_live,
  protocol: protocol,
  checksum: checksum,
  src_addr: src_addr,
  dst_addr: dst_addr
)

icmp_header = ICMPHeader.new(
  type: 0x08,
  code: 0,
  id: 0x01,
  seq_number: 0x00af,
  data: "abcd"
)

data = ip_header.to_pack + icmp_header.to_pack

pp data.length # J\x00\x0E\x1E\x8A\x80\x00@\x00\x80\x00`T\x19\x0F\x04\x04\x04\x04\x00"
#exit

# ★ICMPヘッダ追加してみる
#  send(2) (Errno::EINVAL)
socket.send(data, 0, SockAddressLL.new("eth1").to_pack_from)
