defmodule QL2 do
  @moduledoc """
  Defines the records based on the file ql2.proto
  to be used in communicating with rethinkdb.
  """
  use Protobuf, from: Path.expand("../proto/ql2.proto", __DIR__), only: [:Term, :AssocPair, :VersionDummy, :Version]

  @doc """
  Helper to get a proto version
  """
  def version(v \\ :V0_2) do
    QL2.VersionDummy.Version.value(v)
  end

  @doc """
  Helper to create a global database message to use
  in query global_opts.
  """
  def global_database(database) do
    QL2.Query.AssocPair.new(
      key: "db", val: Rethinkdb.Rql.db(database).build
    )
  end
end
