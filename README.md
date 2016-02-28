# LogServer
- Elixir Application module used to start a GenServer based UDP Server on a user defined port
- can pass log handler callback as `:log_handler` application environment config

### Example config
```
	config :log_server,
	ip: {127,0,0,1},
	port: 1514,
	log_handler: {module, function}
```
 
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add log_server to your list of dependencies in `mix.exs`:

        def deps do
          [{:log_server, git: "https://github.com/harmon25/elixir_log_server.git"}]
        end

