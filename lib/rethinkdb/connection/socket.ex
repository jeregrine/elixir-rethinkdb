defmodule Rethinkdb.Connection.Socket do
  alias Rethinkdb.Connection.Options

  defstruct socket: nil
  @type t :: __MODULE__

  defmodule Error do
    defexception code: nil, msg: nil
    @type t :: Error.t

    def message(%Error{code: code, msg: nil}) do
      "(#{code}) #{unix_error(code)}"
    end

    def message(%__MODULE__{msg: msg}) do
      to_string(msg)
    end

    defp unix_error(:timeout), do: "timeout recv"
    defp unix_error(code), do: :inet.format_error(code)
  end

  # Open connect in passive mode
  def connect!(%Options{host: address, port: port}) do
    address = String.to_char_list(address)

    opts = [:binary | [packet: :raw, active: false]]
    case :gen_tcp.connect(address, port, opts) do
      { :ok, socket }  -> %__MODULE__{socket: socket}
      { :error, code } -> raise Error, code: code
    end
  end

  @spec process!(t,pid) :: t | no_return
  def process!(%__MODULE__{socket: socket} = record, pid) do
    case :gen_tcp.controlling_process(socket, pid) do
      :ok -> record
      {:error, msg} -> raise Error, msg: msg
    end
  end

  @spec active!(t) :: :t | no_return
  def active!(mode \\ true, %__MODULE__{socket: socket} = record) do
    case :inet.setopts(socket, active: mode) do
      :ok -> record
      {:error, code} -> raise Error, code: code
    end
  end

  @spec tcp_send(iodata, t) :: :ok | { :error, Error.t }
  def tcp_send(data, %__MODULE__{socket: socket}) do
    :gen_tcp.send(socket, data)
  end

  @spec tcp_send!(iodata, t) :: :ok | no_return
  def tcp_send!(data, record) do
    case tcp_send(data, record) do
      :ok -> :ok
      other -> error_raise(other)
    end
  end

  @spec recv!(number, t) :: binary
  def recv!(length \\ 0, timeout \\ :infinity, %__MODULE__{socket: socket}) do
    case :gen_tcp.recv(socket, length, timeout) do
      {:ok, data} -> data
      other -> error_raise(other)
    end
  end

  ## Loop to recv and accumulate data from the socket
  @spec recv_until_null!(number, t) :: binary
  def recv_until_null!(timeout, %__MODULE__{} = record) when is_number(timeout) do
    recv_until_null!(<<>>, timeout, record)
  end

  @spec recv_until_null!(binary, number, t) :: binary
  defp recv_until_null!(acc, timeout, %__MODULE__{} = record) do
    result = << acc :: binary, recv!(0, timeout, record) :: binary >>
    case String.slice(result, -1, 1) do
      << 0 >> ->
        String.slice(result, 0, :erlang.iolist_size(result) - 1)
      _ -> recv_until_null!(result, timeout, record)
    end
  end

  @spec open?(t) :: boolean
  def open?(%__MODULE__{socket: socket}) do
    case :inet.sockname(socket) do
      { :ok, _ } -> true
      _ -> false
    end
  end

  @spec close(t) :: t
  def close(%__MODULE__{socket: socket} = record) do
    :gen_tcp.close(socket); record
  end

  defp error_raise({:error, :closed}) do
    raise Error, msg: "Socket is closed"
  end

  defp error_raise({:error, code}) do
    raise Error, code: code
  end
end
