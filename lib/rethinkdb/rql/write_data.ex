defmodule Rethinkdb.Rql.WriteData do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def insert(data, opts \\ [], %{} = query) do
        new_term(:'INSERT', [data], opts, query)
      end

      def update(data, %{} = query) do
        update(data, [], query)
      end

      def update(func, opts, %{} = query) when is_function(func) do
        update(func(func), opts, query)
      end

      def update(data, opts, %{} = query) do
        new_term(:'UPDATE', [expr(data)], opts, query)
      end

      def replace(data, %{} = query) do
        replace(data, [], query)
      end

      def replace(func, opts, %{} = query) when is_function(func) do
        replace(func(func), opts, query)
      end

      def replace(data, opts, %{} = query) do
        new_term(:'REPLACE', [data], opts, query)
      end

      def delete(opts \\ [], %{} = query) do
        new_term(:'DELETE', [], opts, query)
      end
    end
  end
end

