defmodule Rethinkdb.Connection.Authentication do
  alias Rethinkdb.Connection.Options
  alias Rethinkdb.Connection.Socket

  alias Rethinkdb.RqlDriverError


  @spec auth!(Socket.t, Options.t) :: :ok | no_return
  def auth!(%Socket{} = socket, %Options{auth_key: auth_key, timeout: timeout} = options) do
    version = :binary.encode_unsigned(QL2.version, :little)
    auth_key = [version, <<:erlang.iolist_size(auth_key) :: size(32)-little>>, auth_key]
    :ok = socket.tcp_send!(auth_key)

    case socket.recv_until_null!(timeout * 1000) do
      "SUCCESS" -> :ok
      response ->
        raise RqlDriverError, msg:
          "Authentication to #{options.host}:#{options.port} fail with #{response}"
    end
  end
end
