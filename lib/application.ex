defmodule LogServer do
  use Application
  require Logger
 
  def start(_type , _args) do
    import Supervisor.Spec, warn: false

    children = [
        worker(LogServer.Server, [&__MODULE__.emit/3, Application.get_env(:log_server, :port)] )
      ]
    opts = [strategy: :one_for_one, name: LogServer.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def emit(ip, fromport, packet) do
    Logger.info("#{format_ip(ip)}:#{fromport} sent: #{String.strip(packet)}")
  end
  
  #ip is passed as a tuple one int each octet {127,0,0,1}
  defp format_ip ({a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end
end