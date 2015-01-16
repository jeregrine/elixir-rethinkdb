defmodule QL2.ResponseHelpers do
  defmacro __using__(_opts) do
    quote do
      @type response :: success | error
      @type success :: {:ok, [any]}
      @type error :: {:error, binary, atom, any}

      @spec value(__MODULE__.t) :: response
      def value(%__MODULE__{type: type, response: [datum]}) when
        type in [:'SUCCESS_ATOM', :'SUCCESS_PARTIAL'] do
        {:ok, datum.value}
      end

      def value(%__MODULE__{type: :'SUCCESS_SEQUENCE', response: data}) do
        response = for datum <- data, do: datum.value
        {:ok, response}
      end

      def value(%__MODULE__{type: type, response: [errorMsg], backtrace: backtrace}) do
        {:error, type, errorMsg.value, backtrace}
      end
    end
  end
end
