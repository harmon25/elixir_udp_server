defmodule LogServer.Server do
  use GenServer
  require Logger

  # if port is not passed to LogServer.Supervisor.start_link use defauult struct port : 1514
  def start_link(handler, port \\ %LogServer.Listener{}.port) do
    GenServer.start_link(__MODULE__, [%LogServer.Listener{handler: handler, port: port}], name: __MODULE__)
  end

  def init([%LogServer.Listener{} = state]) do
    {:ok, socket} = :gen_udp.open(state.port, [:binary, :inet,
                                               {:ip, {127,0,0,1}},
                                               {:active, true}])
    {:ok, port} = :inet.port(socket)
    Logger.info("listening on port #{port}")
    #update state
    {:ok, %{state | socket: socket, port: port}}
  end

  def terminate(_reason, %LogServer.Listener{socket: socket} = state) when socket != nil do
    Logger.info("closing port #{state.port}")
    :ok = :gen_udp.close(socket)
  end

  def handle_info({:udp, socket, ip, fromport, packet}, %LogServer.Listener{socket: socket} = state) do
    state.handler.(ip, fromport, packet)
    {:noreply, state}
  end
end