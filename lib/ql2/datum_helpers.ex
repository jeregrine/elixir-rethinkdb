defmodule QL2.Datum do
  alias Rethinkdb.Rql

  use Protobuf, from: Path.expand("../../proto/ql2.proto", __DIR__), only: :Datum, inject: true

  @typep json_term :: :null | boolean | number | binary | Dict.t | [json_term]
  @typep t :: __MODULE__

  @spec value(t) :: json_term
  def value(%__MODULE__{type: :'R_NULL'}) do
    nil
  end

  def value(%__MODULE__{type: :'R_BOOL', r_bool: bool}) do
    bool
  end

  def value(%__MODULE__{type: :'R_NUM', r_num: num}) do
    num
  end

  def value(%__MODULE__{type: :'R_STR', r_str: str}) do
    str
  end

  def value(%__MODULE__{type: :'R_ARRAY', r_array: array}) do
    for item <- array, do: value(item)
  end

  def value(%__MODULE__{type: :'R_OBJECT', r_object: object}) do
    HashDict.new(for %QL2.Datum.AssocPair{key: key, val: value} <- object do
      {:'#{key}', value(value)}
    end)
  end

  @spec from_value(json_term) :: t
  def from_value(value) do
    case value do
      null when null == nil or null == :null ->
        new(type: :'R_NULL')
      bool when is_boolean(bool) ->
        new(type: :'R_BOOL', r_bool: bool)
      num  when is_number(num) ->
        new(type: :'R_NUM', r_num: num)
      str  when is_bitstring(str) ->
        new(type: :'R_STR', r_str: str)
      atom when is_atom(atom) ->
        new(type: :'R_STR', r_str: "#{atom}")
      %Rql{} = rql ->
        Rql.build(rql)
      %{} = obj ->
        object = for {key, value} <- Map.to_list(obj) do
          QL2.Datum.AssocPair.new(key: "#{key}", val: from_value(value))
        end
        new(type: :'R_OBJECT', r_object: object)
      [{_, _} | _] = obj ->
        object = for {key, value} <- obj do
          QL2.Datum.AssocPair.new(key: "#{key}", val: from_value(value))
        end
        new(type: :'R_OBJECT', r_object: object)
      list when is_list(list) ->
        values = for item <- list, do: from_value(item)
        new(type: :'R_ARRAY', r_array: values)
    end
  end
end
