defmodule Rethinkdb.Rql.SelectingData do
  @moduledoc false

  alias Rethinkdb.RqlDriverError

  defmacro __using__(_opts) do
    quote do
      def db(name) do
        new_term(:'DB', [name])
      end

      def table(name, %Rql{} = query \\ %Rql{}) do
        new_term(:'TABLE', [name], query)
      end

      def get(id, %Rql{} = query) do
        new_term(:'GET', [id], [], query)
      end

      # TODO: replace for get_all
      def getAll(ids, %Rql{} = query) do
        getAll(ids, [], query)
      end

      def getAll(ids, opts, %Rql{} = query) when not is_list(ids) do
        getAll([ids], opts, query)
      end

      def getAll(ids, opts, %Rql{} = query) do
        new_term(:'GET_ALL', ids, opts, query)
      end

      def between(_left_bound, _right_bound, %Rql{} = _query) do
        RqlDriverError.not_implemented(:between)
      end

      def filter(%Rql{} = predicate, %Rql{} = query) do
        filter(fn _ -> predicate end, query)
      end

      def filter(func, %Rql{} = query) when is_function(func) do
        new_term(:'FILTER', [func(func)], query)
      end

      def filter(predicate, %Rql{} = query) do
        new_term(:'FILTER', [predicate], query)
      end
    end
  end
end

