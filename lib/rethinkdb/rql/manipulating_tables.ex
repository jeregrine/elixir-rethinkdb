defmodule Rethinkdb.Rql.ManipulatingTables do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      # TODO: Test options
      def table_create(name, %{} = query) do
        table_create(name, [], query)
      end

      def table_create(name, opts \\ [], %{} = query \\ %{}) do
        new_term(:'TABLE_CREATE', [name], opts, query)
      end

      def table_drop(name, %{} = query \\ %{}) do
        new_term(:'TABLE_DROP', [name], [], query)
      end

      def table_list(%{} = query \\ %{}) do
        new_term(:'TABLE_LIST', [], query)
      end

      def index_create(index, %{} = query) do
        new_term(:'INDEX_CREATE', [index], query)
      end

      def index_create(index, func, %{} = query) do
        new_term(:'INDEX_CREATE', [index, func(func)], query)
      end

      def index_drop(index, %{} = query) do
        new_term(:'INDEX_DROP', [index], query)
      end

      def index_list(%{} = query) do
        new_term(:'INDEX_LIST', [], query)
      end
    end
  end
end
