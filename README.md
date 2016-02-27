# LogServer
- Elixir Application module used to start a supervised UDP Server on a user defined port
 
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add log_server to your list of dependencies in `mix.exs`:

        def deps do
          [{:log_server, git: "https://github.com/harmon25/elixir_log_server.git"}]
        end

  2. Ensure log_server is started before your application:

        def application do
          [applications: [:log_server]]
        end

