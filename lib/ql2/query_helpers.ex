defmodule QL2.Query do
  use Protobuf, from: Path.expand("../../proto/ql2.proto", __DIR__), only: :Query, inject: true

  @type t  :: __MODULE__
  @type db :: String.t

  @spec new_start(tuple, db , number) :: t
  def new_start(term, db, token) do
    Query.new( 
      type: :'START', query: term,
      token: token, global_optargs: [QL2.global_database(db)]
    )
  end
end

