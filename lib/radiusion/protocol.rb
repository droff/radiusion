module Radiusion
  class Protocol
    def initialize(host, port, timeout)
      @host = host
      @port = port
      @timeout = timeout

      @socket = UDPSocket.new
      @socket.connect(@host, @port)
    end

    def send(packet)
      @socket.send(packet, 0)
    end

    def recv
      if select([@socket], nil, nil, @timeout).nil?
        "unable to receive"
      else
        @socket.recvfrom(4096)
      end
    end
  end
end
