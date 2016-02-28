defmodule LogServer.Listener do
  @doc ~S"""
  Struct used for LogServer.Server state
  port :: integer
  count :: integer
  handler :: function
  socket :: %Socket
  """
  defstruct port: nil, ip: {nil,nil,nil,nil} ,handler: {nil, nil}, socket: nil, count: 0
  @type t :: %__MODULE__{port: integer, ip: tuple, handler: tuple, socket: reference, count: integer}
end

defmodule LogServer.Response do
  @doc ~S"""
  Struct for UDP response packet
  ip :: String.t
  fromport :: integer
  packet :: String.t
  """
  defstruct ip: nil, fromport: nil, packet: nil
  @type t :: %__MODULE__{ip: String.t, fromport: integer, packet: String.t}
end

defmodule LogServer do
  use GenServer
  alias LogServer.Listener
  alias LogServer.Response

  def start_link() do
    {mod, fun} = Application.get_env :log_server, :log_handler, {__MODULE__, :default_handler}
    {ip, port} = {Application.get_env(:log_server, :ip, {127,0,0,1}), Application.get_env(:log_server, :port, 1514)}
    GenServer.start_link(__MODULE__, [%Listener{handler: {mod,fun}, ip: ip, port: port}], name: __MODULE__)
  end

  def init([%Listener{} = state]) do
    require Logger
    {:ok, socket} = :gen_udp.open(state.port, [:binary, :inet,
                                               {:ip, state.ip},
                                               {:active, true}])
    {:ok, port} = :inet.port(socket)
    Logger.info("listening on port #{port}")
    #update state
    {:ok, %{state | socket: socket, port: port}}
  end

  def terminate(_reason, %Listener{socket: socket} = state) when socket != nil do
    require Logger
    Logger.info("closing port #{state.port}")
    :ok = :gen_udp.close(socket)
  end

  def handle_info({:udp, socket, ip, fromport, packet}, %Listener{socket: socket, handler: {mod, fun}} = state) do
    new_count = state.count + 1
    apply mod, fun, [%Response{ip: format_ip(ip), fromport: fromport, packet: String.strip(packet)}]
    {:noreply, %Listener{state | count: new_count}}
  end

  def default_handler(%Response{} = response) do
    require Logger
    Logger.info("#{response.ip}:#{response.fromport} sent: #{response.packet}")
  end

  #ip is passed as a tuple one int each octet {127,0,0,1}
  defp format_ip ({a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end
end