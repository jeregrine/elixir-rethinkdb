defmodule Rethinkdb.Rql.SelectingData do
  @moduledoc false

  alias Rethinkdb.RqlDriverError

  defmacro __using__(_opts) do
    quote do
      def db(name) do
        new_term(:'DB', [name])
      end

      def table(name, %{} = query \\ %{}) do
        new_term(:'TABLE', [name], query)
      end

      def get(id, %{} = query) do
        new_term(:'GET', [id], [], query)
      end

      # TODO: replace for get_all
      def getAll(ids, %{} = query) do
        getAll(ids, [], query)
      end

      def getAll(ids, opts, %{} = query) when not is_list(ids) do
        getAll([ids], opts, query)
      end

      def getAll(ids, opts, %{} = query) do
        new_term(:'GET_ALL', ids, opts, query)
      end

      def between(_left_bound, _right_bound, %{} = _query) do
        RqlDriverError.not_implemented(:between)
      end

      def filter(%{} = predicate, %{} = query) do
        filter(fn _ -> predicate end, query)
      end

      def filter(func, %{} = query) when is_function(func) do
        new_term(:'FILTER', [func(func)], query)
      end

      def filter(predicate, %{} = query) do
        new_term(:'FILTER', [predicate], query)
      end
    end
  end
end

