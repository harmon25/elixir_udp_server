#handler is callback used once a packet is recieved...
#socket is socket returned from :udp.open
# port is the port to start listener on, can by configured...
defmodule LogServer.Listener do
	@doc "Struct used for LogServer.Server state"
	defstruct [port: 1514,
	           handler: nil,
	           socket: nil]
end