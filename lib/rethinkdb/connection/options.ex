defmodule Rethinkdb.Connection.Options do

  @host "localhost"
  @port 28015
  @timeout 20
  @auth_key ""
  @db nil

  defstruct id: nil, host: @host, port: @port, auth_key: @auth_key, timeout: @timeout, db: @db
  @type t   :: __MODULE__
  @type uri :: String.t


  @doc """
  Return a new options according to the instructions
  of the uri.

  ## Example

      iex> #{__MODULE__}.new("rethinkdb://#{@host}:#{@port}/test")
      #{__MODULE__}[host: "localhost", port: 28015, auth_key: nil, timeout: 20, db: "test"]
  """
  @spec new(uri) :: t
  def new(uri) when is_binary(uri) do
    extract_from_uri(URI.parse(uri))
  end

  @doc """
  Return a uri representation from a options record.

  ## Example

      iex> Options.new(db: "teste").to_uri
      "rethinkdb://#{@host}:#{@port}/test
  """
  @spec to_uri(t) :: String.t
  def to_uri(%__MODULE__{db: db, port: port, host: host, auth_key: auth_key}) do
    if auth_key != nil do
      auth_key = "#{auth_key}@"
    end
    "rethinkdb://#{auth_key}#{host}:#{port}/#{db}"
  end

  # New record from valid uri scheme
  defp extract_from_uri(%URI{scheme: "rethinkdb", host: host, port: port, userinfo: auth_key, path: db}) do
    db = List.last(String.split(db || "", "/"))
    %__MODULE__{
      host: host,
      port: port || @port,
      auth_key: auth_key || @auth_key,
      db: db != "" && db || @db
    }
  end

  defp extract_from_uri(_) do
    {:error, "invalid uri, ex: rethinkdb://#{@auth_key}:#{@db}/[database]"}
  end
end
