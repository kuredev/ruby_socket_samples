class IPHeader
  def initialize(version:, header_length:, tos:, total_length:,
                 id:, flags:, fragment:, time_to_live:, protocol:,
                 checksum:, src_addr:, dst_addr:)
    @version = version
    @header_length = header_length
    @tos = tos
    @total_length = total_length
    @id = id
    @flags = flags
    @fragment = fragment
    @time_to_live = time_to_live
    @protocol = protocol
    @checksum = checksum
    @src_addr = src_addr
    @dst_addr = dst_addr
  end

  # ★
  def to_pack
    bynary_data =
      @version.to_s(2).rjust(4, "0") +
      @header_length.to_s(2).rjust(4, "0") +
      @tos.to_s(2).rjust(8, "0") +
      @total_length.to_s(2).rjust(16, "0") +
      @id.to_s(2).rjust(16, "0") +
      @flags.to_s(2).rjust(3, "0") +
      @fragment.to_s(2).rjust(13, "0") +
      @time_to_live.to_s(2).rjust(8, "0") +
      @protocol.to_s(2).rjust(8, "0") +
      @checksum.to_s(2).rjust(16, "0") +
      IPAddr.new(@src_addr).to_i.to_s(2).rjust(32, "0") +
      IPAddr.new(@dst_addr).to_i.to_s(2).rjust(32, "0")

    data_byte_arr = bynary_data.scan(/.{1,8}/)
    data_byte_arr.map! { |byte| byte.to_i(2).chr } # TO ASCII
    data_byte_arr.join
  end
end
