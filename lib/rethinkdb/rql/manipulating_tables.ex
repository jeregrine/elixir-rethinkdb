defmodule Rethinkdb.Rql.ManipulatingTables do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      # TODO: Test options
      def table_create(name, %Rql{} = query) do
        table_create(name, [], query)
      end

      def table_create(name, opts \\ [], %Rql{} = query \\ %Rql{}) do
        new_term(:'TABLE_CREATE', [name], opts, query)
      end

      def table_drop(name, %Rql{} = query \\ %Rql{}) do
        new_term(:'TABLE_DROP', [name], [], query)
      end

      def table_list(%Rql{} = query \\ %Rql{}) do
        new_term(:'TABLE_LIST', [], query)
      end

      def index_create(index, %Rql{} = query) do
        new_term(:'INDEX_CREATE', [index], query)
      end

      def index_create(index, func, %Rql{} = query) do
        new_term(:'INDEX_CREATE', [index, func(func)], query)
      end

      def index_drop(index, %Rql{} = query) do
        new_term(:'INDEX_DROP', [index], query)
      end

      def index_list(%Rql{} = query) do
        new_term(:'INDEX_LIST', [], query)
      end
    end
  end
end
