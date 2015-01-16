defmodule Rethinkdb do
  alias Rethinkdb.Rql
  alias Rethinkdb.Connection

  defmacro __using__(_opts) do
    helper(__CALLER__.module)
  end

  def start do
    Rethinkdb.App.start
  end

  # Import rr in Iex to not conflict Iex.Helper.r
  defp helper(module) do
    method = module && :r || :rr
    quote do
      import(Rql, only: [{unquote(method), 0}])
      alias unquote(__MODULE__).RqlDriverError
      alias unquote(__MODULE__).RqlRuntimeError
    end
  end
  defmodule RqlDriverError do
    defexception msg: nil, backtrace: nil

    def message(%RqlDriverError{msg: msg}) do
      msg
    end

    def not_implemented(method) do
      raise(RqlDriverError, msg: "#{method} not implemented yet")
    end
  end

  defmodule RqlRuntimeError do
    defexception msg: nil, type: nil, backtrace: nil 
    def message(%__MODULE__{msg: msg, type: type}) do
      "#{type}: #{msg}"
    end
  end
end


