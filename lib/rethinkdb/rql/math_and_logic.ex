defmodule Rethinkdb.Rql.MathAndLogic do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def add(value, %{} = query) do
        new_term(:'ADD', [value], query)
      end

      def sub(value, %{} = query) do
        new_term(:'SUB', [value], query)
      end

      def mul(value, %{} = query) do
        new_term(:'MUL', [value], query)
      end

      def div(value, %{} = query) do
        new_term(:'DIV', [value], query)
      end

      def mod(value, %{} = query) do
        new_term(:'MOD', [value], query)
      end

      def _and(value, %{} = query) do
        new_term(:'ALL', [value], query)
      end

      def _or(value, %{} = query) do
        new_term(:'ANY', [value], query)
      end

      def _not(%{} = query) do
        new_term(:'NOT', [], query)
      end

      def eq(value, %{} = query) do
        new_term(:'EQ', [value], query)
      end

      def ne(value, %{} = query) do
        new_term(:'NE', [value], query)
      end

      def gt(value, %{} = query) do
        new_term(:'GT', [value], query)
      end

      def ge(value, %{} = query) do
        new_term(:'GE', [value], query)
      end

      def lt(value, %{} = query) do
        new_term(:'LT', [value], query)
      end

      def le(value, %{} = query) do
        new_term(:'LE', [value], query)
      end
    end
  end
end
