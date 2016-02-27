defmodule UDPServer.Worker do
    
  def start_link() do
    GenServer.start_link(__MODULE__, [%UDPServer.Listener{handler: &UDPServer.handle_packet/1, port: Application.get_env(:udp_server, :port )}], name: __MODULE__)
  end

  def init([%UDPServer.Listener{} = state]) do
  	require Logger
    {:ok, socket} = :gen_udp.open(state.port, [:binary, :inet,
                                               {:ip, {127,0,0,1}},
                                               {:active, true}])
    {:ok, port} = :inet.port(socket)
    Logger.info("listening on port #{port}")
    #update state
    {:ok, %{state | socket: socket, port: port}}
  end

  def terminate(_reason, %UDPServer.Listener{socket: socket} = state) when socket != nil do
  	require Logger
    Logger.info("closing port #{state.port}")
    :ok = :gen_udp.close(socket)
  end

  def handle_info({:udp, socket, ip, fromport, packet}, %UDPServer.Listener{socket: socket} = state) do
    new_count = state.count + 1
    state.handler.(%UDPServer.Response{ip: format_ip(ip), fromport: fromport, packet: String.strip(packet)})
    {:noreply, %UDPServer.Listener{state | count: new_count}}
  end

  #ip is passed as a tuple one int each octet {127,0,0,1}
  defp format_ip ({a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end

end