defmodule LogServer.Supervisor do
  use Supervisor

  @doc "Given an arity-3 handler function and an optional listen port, supervise a server
  which calls the handler with (ip, from_port, packet) for UDP packets received on that
  port."
  def start_link(handler, port \\ %LogServer.Listener{}.port ) do
    Supervisor.start_link(__MODULE__, [handler,port], name: __MODULE__)
  end

  def init(params) do
    children = [worker(LogServer.Server, params)]
    supervise(children, strategy: :one_for_one)
  end
end