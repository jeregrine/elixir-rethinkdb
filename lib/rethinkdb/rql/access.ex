defmodule Rethinkdb.Rql.Access do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def access(index, %Rql{} = query) when is_number(index) do
        new_term(:'NTH', [index], query)
      end

      def access({Range, start_index, end_index}, %Rql{} = query) do
        opts = case end_index do
          n when n < 0 -> [right_bound: :closed]
          _ -> []
        end
        new_term(:'SLICE', [start_index, end_index], opts, query)
      end

      def access(key, %Rql{} = query) do
        new_term(:'GET_FIELD', [key], [], query)
      end
    end
  end
end

defimpl Access, for: Rethinkdb.Rql do
  def access(rql, key) do
    Rethinkdb.Rql.access(key, rql)
  end
end
