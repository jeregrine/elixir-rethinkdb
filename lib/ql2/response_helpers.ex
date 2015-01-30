defmodule QL2.Response do
  use Protobuf, from: Path.expand("../../proto/ql2.proto", __DIR__), only: :Response, inject: true

  @type response :: success | error
  @type success :: {:ok, [any]}
  @type error :: {:error, binary, atom, any}

  @spec value(__MODULE__) :: response
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
