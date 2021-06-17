class ICMPHeader
  def initialize(type:, code:, id:, seq_number:, data:)
    @type = type
    @code = code
    @id = id
    @seq_number = seq_number
    @data = data
    @checksum = checksum
  end

  def to_pack
    bynary_data =
      @type.to_s(2).rjust(8, "0") +
      @code.to_s(2).rjust(8, "0") +
      @checksum.to_s(2).rjust(16, "0") +
      @id.to_s(2).rjust(16, "0") + # 0x01 -> 00000000 00000001
      @seq_number.to_s(2).rjust(16, "0")

    data_byte_arr = bynary_data.scan(/.{1,8}/)
    data_byte_arr.map! { |byte| byte.to_i(2).chr } # TO ASCII
    data_byte_arr.join + @data
  end

  private

  # Calculate carry in 16bit
  # memo: https://qiita.com/kure/items/fa7e665c2259375d9a81
  #
  # @param num [String] ex: "11001100110100011"
  # @return [Integer]
  def carry_up(num)
    carry_up_num = num.length - 16
    original_value = num[carry_up_num, 16]
    carry_up_value = num[0, carry_up_num]
    sum = original_value.to_i(2) + carry_up_value&.to_i(2)
    sum ^ 0xffff
  end

  # 間違っているみたい。
  # return checksum value
  # Calculate 1's complement sum for each 16 bits
  # memo: https://qiita.com/kure/items/fa7e665c2259375d9a81
  #
  # @return [Integer]
  def checksum
    # Divide into 16 bits
    # ex: ["pi", "ng"]
    data_arr = @data.scan(/.{1,2}/)
    # Calculate each ASCII code
    # ex: [28777, 28263]
    data_arr_int = data_arr.map do |data|
      (data.bytes[0] << 8) + (data.bytes[1].nil? ? 0 : data.bytes[1])
    end
    data_sum = data_arr_int.sum

    sum_with_16bit = (@type << 8 + @code) + @id + @seq_number + data_sum

    # calculate carry
    carry_up(sum_with_16bit.to_s(2).rjust(16, "0"))
  end
end
