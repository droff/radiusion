require 'rubygems'
require_relative 'lib/radiusion'
include Radiusion

HOST    = "192.168.1.22"
PORT    = 1812
SECRET  = "s3cret"
USER    = "droff"
PASS    = "555666"

ID      = 1
AUTH_ID = "\000" * 16

@packet = Packet.new('Access-Request', ID, AUTH_ID)
@packet.set_attribute('User-Name', USER)
@packet.set_attribute_cipher('User-Password', PASS, SECRET)
@packet.set_attribute('NAS-IP-Address', "127.0.0.1")
@packet.set_attribute('NAS-Port', 0)

radius = Protocol.new(HOST, PORT, 1)
radius.send(@packet.pack)
data = radius.recv
puts @packet.unpack(data[0]) if data
