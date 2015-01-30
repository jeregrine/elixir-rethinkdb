defmodule Rethinkdb.Rql.ManipulatingString do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def match(regexp, %{} = query) do
        new_term(:'MATCH', [regexp], query)
      end
    end
  end
end

