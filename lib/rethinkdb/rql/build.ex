defmodule Rethinkdb.Rql.Build do
  @moduledoc false
  alias QL2.Datum
  alias QL2.Term

  defmacro __using__(_opts) do
    quote do
      # Build a rql terms in a ql2 terms
      @doc false
      def build(%{terms: terms}) do
        Enum.reduce terms, nil, &build_terms(&1, &2)
      end

      defp build_term_datum(value) do
        Term.new(type: :'DATUM', datum: Datum.from_value(value))
      rescue
        x -> raise "Error to create Datum from: #{inspect(value)}"
      end

      defp build_terms(%{type: :'EXPR', args: [value]}, _left) do
        build_term_datum(value)
      end

      defp build_terms(%{type: type, args: args, optargs: optargs}, left) do
        optargs = format_opts(optargs)
        args    = format_args(args)
        if left != nil, do: args = [left | args]
        Term.new(type: type, args: args, optargs: optargs)
      end

      defp format_args(args) do
        for arg <- args, do: format_arg(arg)
      end

      defp format_opts(optargs) do
        for {key, value} <- optargs do
          Term.AssocPair.new(key: "#{key}", val: format_arg(value))
        end
      end

      defp format_arg(arg) do
        case arg do
          %{__struct__: :Rql}  = rql  -> build(rql)
          %{__struct__: :Term} = term -> build_terms(term, nil)
          arg -> build_term_datum(arg)
        end
      end
    end
  end
end

