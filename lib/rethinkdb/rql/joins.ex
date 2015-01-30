defmodule Rethinkdb.Rql.Joins do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      # Joins
      def inner_join(sequence, predicate, %{} = query) do
        new_term(:'INNER_JOIN', [sequence, func(predicate)], query)
      end

      def outer_join(sequence, predicate, %{} = query) do
        new_term(:'OUTER_JOIN', [sequence, func(predicate)], query)
      end

      def eq_join(left_attr, other_table, %{} = query) do
        eq_join(left_attr, other_table, [], query)
      end

      def eq_join(left_attr, other_table, opts, %{} = query) do
        new_term(:'EQ_JOIN', [left_attr, other_table], opts, query)
      end

      def zip(%{} = query) do
        new_term(:'ZIP', [], query)
      end
    end
  end
end

