defmodule LogServer do
  use Application 
  
  # start app, :normal type, LogServer.Listener passed all the way through as args
  def start(_type \\ :normal, args \\ &__MODULE__.emit/3) do
  	#start_link runs this modules emit function, as the default handler when a UDP packet is recieved
    LogServer.Supervisor.start_link(args)
  end

  def emit(ip, fromport, packet) do
    IO.puts("#{format_ip(ip)}:#{fromport} sent: #{String.strip(packet)}")
  end
  
  #ip is passed as a tuple one int each octet {127,0,0,1}
  defp format_ip ({a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end
end