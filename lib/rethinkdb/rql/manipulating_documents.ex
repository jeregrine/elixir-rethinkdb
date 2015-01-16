defmodule Rethinkdb.Rql.ManipulatingDocument do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def row do
        new_term(:'IMPLICIT_VAR', [])
      end

      def pluck(selector, %Rql{} = query) do
        new_term(:'PLUCK', [selector], query)
      end

      def without(selector, %Rql{} = query) do
        new_term(:'WITHOUT', [selector], query)
      end

      def merge(object, %Rql{} = query) do
        new_term(:'MERGE', [expr(object)], [], query)
      end

      def literal(object \\ nil) do
        new_term(:'LITERAL', object && [object] || [])
      end

      def append(value, %Rql{} = query) do
        new_term(:'APPEND', [value], query)
      end

      def prepend(value, %Rql{} = query) do
        new_term(:'PREPEND', [value], query)
      end

      def difference(array, %Rql{} = query) do
        new_term(:'DIFFERENCE', [array], query)
      end

      def set_insert(value, %Rql{} = query) do
        new_term(:'SET_INSERT', [value], query)
      end

      def set_intersection(array, %Rql{} = query) do
        new_term(:'SET_INTERSECTION', [array], query)
      end

      def set_difference(array, %Rql{} = query) do
        new_term(:'SET_DIFFERENCE', [array], query)
      end

      def has_fields(selectors, %Rql{} = query) do
        new_term(:'HAS_FIELDS', [selectors], query)
      end

      def insert_at(index, value, %Rql{} = query) do
        new_term(:'INSERT_AT', [index, value], query)
      end

      def splice_at(index, array, %Rql{} = query) do
        new_term(:'SPLICE_AT', [index, array], query)
      end

      def delete_at(index, endindex \\ nil, %Rql{} = query) do
        new_term(:'DELETE_AT', [index | endindex && [endindex] || []], query)
      end

      def change_at(index, value, %Rql{} = query) do
        new_term(:'CHANGE_AT', [index, value], query)
      end

      def keys(%Rql{} = query) do
        new_term(:'KEYS', [], query)
      end
    end
  end
end

