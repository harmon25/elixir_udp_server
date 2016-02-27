defmodule UDPServer.Handler do

defmacro __using__(_) do 
		quote do
		  def handle_packet(%UDPServer.Response{} = response) do
		  	require Logger
		    Logger.info("#{response.ip}:#{response.fromport} sent: #{response.packet}")
		  end	  
		  defoverridable Module.definitions_in(__MODULE__)
		 end
	 end

end