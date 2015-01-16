defmodule Rethinkdb.App do
  use Application

  def start do
    Application.start(:rethinkdb)
  end

  def start(_type, _args) do
    Rethinkdb.Supervisor.start_link
  end
end
