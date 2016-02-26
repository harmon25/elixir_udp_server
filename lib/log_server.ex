defmodule LogServer do
  def start do
  	#start_link runs this module emit function, as the handler when a UDP packet is recieved
    LogServer.Supervisor.start_link(&__MODULE__.emit/3)
  end

  def emit(ip, fromport, packet) do
    IO.puts("#{format_ip(ip)}:#{fromport} sent: #{String.strip(packet)}")
  end
  
  #ip is passed as a tuple one int each octet {127,0,0,1}
  defp format_ip ({a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end
end