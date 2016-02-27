defmodule LogServer.Server do
  use GenServer

  # if port is not passed to LogServer.Supervisor.start_link use defauult struct port : 1514
  def start_link(%LogServer.Listener{handler: _handler, port: _port} = state) do
    GenServer.start_link(__MODULE__, [state])
  end

  def init([%LogServer.Listener{} = state]) do
    {:ok, socket} = :gen_udp.open(state.port, [:binary, :inet,
                                               {:ip, {127,0,0,1}},
                                               {:active, true}])
    {:ok, port} = :inet.port(socket)
    IO.puts("listening on port #{port}")
    #update state
    {:ok, %{state | socket: socket, port: port}}
  end

  def terminate(_reason, %LogServer.Listener{socket: socket} = state) when socket != nil do
    IO.puts("closing port #{state.port}")
    :ok = :gen_udp.close(socket)
  end

  def handle_info({:udp, socket, ip, fromport, packet}, %LogServer.Listener{socket: socket} = state) do
    state.handler.(ip, fromport, packet)
    {:noreply, state}
  end
end