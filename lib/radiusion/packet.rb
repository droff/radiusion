require 'digest/md5'
require 'ipaddr_extensions'
require_relative '../radiusion'

module Radiusion
  class Packet
    T_VALUES = "CCa*"
    T_PACKET = "CCna16a*"

    CODES = { 'Access-Request' => 1, 'Access-Accept' => 2,
              'Access-Reject' => 3, 'Accounting-Request' => 4,
              'Accounting-Response' => 5, 'Access-Challenge' => 11,
              'Status-Server' => 12, 'Status-Client' => 13,
              'Disconnect-Request' => 40, 'Disconnect-ACK' => 41,
              'Disconnect-NAK' => 42, 'CoA-Request' => 43,
              'CoA-ACK' => 44, 'CoA-NAK' => 45 }

    def initialize(code, id, authenticator)
      @code = code
      @id = id
      @authenticator = authenticator
      @attributes = {}
    end

    def set_attribute(name, value)
      dict = Dictionary.find(name)
      code = dict[0]
      value =
        case dict[1]
        when "string"  then value
        when "integer" then [value].pack("N")
        when "time"    then [value].pack("N")
        when "date"    then [value].pack("N")
        when "ipaddr"  then [value.to_ip.to_i].pack("N")
        end
      length = value.size
      @attributes[name] = [code, length+2, value].pack(T_VALUES)
    end

    def set_attribute_cipher(name, value, secret)
      dict = Dictionary.find(name)
      code = dict[0]
      value = encode(value, secret)
      length = value.size
      @attributes[name] = [code, length+2, value].pack(T_VALUES)
    end

    def set_attributes
    end

    def pack
      attributes_string = ""
      @attributes.values.each do |attribute|
        attributes_string += attribute
      end

      [CODES[@code], @id, attributes_string.size + 20, @authenticator, attributes_string].pack(T_PACKET)
    end

    private

    def xor(p1, p2)
      c1 = p1.unpack("C*")
      c2 = p2.unpack("C*")
      c1.zip(c2).map{|s1, s2| s1^s2}.pack("C*")
    end

    def encode(value, secret)
      auth = @authenticator
      encoded_value = ""
      value += "\000"*(15-(15+value.size) % 16)
      0.step(value.size-1, 16) do |i|
        auth = xor(value[i, 16], Digest::MD5.digest(secret + auth))
        encoded_value += auth
      end
      encoded_value
    end
  end
end
