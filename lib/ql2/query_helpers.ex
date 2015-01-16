defmodule QL2.QueryHelpers do

  defmacro __using__(_opts) do
    quote do
      @type t  :: __MODULE__
      @type db :: String.t

      @spec new_start(tuple, db , number) :: t
      def new_start(term, db, token) do
        __MODULE__.new( 
          type: :'START', query: term,
          token: token, global_optargs: [QL2.global_database(db)]
        )
      end

      @spec encode_to_send(t) :: binary
      def encode_to_send(%__MODULE__{} = record) do
        data = encode(record)
        [<<:erlang.iolist_size(data) :: size(32)-little>>, data]
      end
    end
  end
end

