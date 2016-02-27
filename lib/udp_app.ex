defmodule UDPServer.Listener do
  @doc ~S"""
  Struct used for LogServer.Server state
  port :: integer
  count :: integer
  handler :: function
  socket :: %Socket
  """
  defstruct port: nil, handler: nil, socket: nil, count: 0
  @type t :: %__MODULE__{port: integer, handler: function, socket: reference, count: integer}
end

defmodule UDPServer.Response do
  @doc ~S"""
  Struct for UDP response packet
  ip :: String.t
  fromport :: integer
  packet :: String.t
  """
  defstruct ip: nil, fromport: nil, packet: nil
  @type t :: %__MODULE__{ip: String.t, fromport: integer, packet: String.t}
end


defmodule UDPServer do
  use UDPServer.Handler
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      worker(UDPServer.Worker, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UDPServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
