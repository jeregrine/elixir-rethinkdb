defmodule Rethinkdb.Rql.TermsConstructor do
  @moduledoc false
  alias Rethinkdb.Rql

  defmacro __using__(_opts) do
    quote do
      defmodule Term do
        defstruct type: nil, args: [], optargs: []
      end

      # Helper to terms create
      defp new_term(type, args \\ []) do
        new_term(type, args, [], %Rql{})
      end

      defp new_term(type, args, nil) do
        new_term(type, args, [], %Rql{})
      end

      defp new_term(type, args, %{} = query) do
        new_term(type, args, [], query)
      end

      defp new_term(type, args, opts) when is_list(opts) do
        new_term(type, args, opts, %Rql{})
      end

      defp new_term(type, args, optargs, %{terms: terms}) do
        %Rql{terms: terms ++ [%Term{type: type, args: args, optargs: optargs}]}
      end

      defp make_array(items) when is_list(items) do
        new_term(:'MAKE_ARRAY', items)
      end

      defp make_obj(values) do
        new_term(:'MAKE_OBJ', [], values)
      end

      defp var(n) do
        new_term(:'VAR', [n])
      end

      # Function helpers
      defp func(func) when is_function(func) do
        {_, arity} = :erlang.fun_info(func, :arity)
        arg_count  = :lists.seq(1, arity)
        func_args  = for n <- arg_count, do: var(n)

        args = case apply(func, func_args) do
          [{key, _}|_] = obj when key != __MODULE__ -> [make_obj(obj)]
          array when is_list(array) -> [make_array(array)]
          %{} = query -> [query]
        end

        new_term(:'FUNC', [expr(arg_count) | args])
      end

      defp func(value), do: value
    end
  end
end

