defmodule ADT.Maybe do
  @moduledoc ~S"""
  `Maybe` encapulates the idea of a value that might not be there.
  This is often a failed computation, but in some cases an empty value may be the
  expected behaviour.

  A `%Maybe{}` value can either be `Just some_value` or `Nothing`. More typical of
  Elixir is to use `{:ok, some_value}`, or `{:error, some_reason}`. By contrast,
  `%Maybe{}` has an implied `:ok`, if there is a value in the `maybe` key.

  Please note that this approach does not track error reasons, as a `Nothing` value
  may not be an error. If you are looking for error tracking behaviour, consider
  `%MaybePlus{}`
  """

  defstruct maybe: nil

  # @type nothing :: :nothing
  # @type just(a) :: any
  # @type maybe(a) :: just(a) | nothing

  # @type maybe(a) :: %ADT.Maybe{maybe: a}
  # @type maybe(a) :: any | :nothing

  @doc "Common useage"
  # @spec from_status_tuple({atom, any}) :: maybe(any)
  def from_status_tuple({:ok,    payload}), do: %ADT.Maybe{maybe: payload}
  def from_status_tuple({:error, reason}),  do: %ADT.Maybe{maybe: nil}

  # @spec just?(maybe(any)) :: boolean
  def just?(%ADT.Maybe{maybe: maybe}), do: !!maybe

  # @spec nothing?(maybe(any)) :: boolean
  def nothing?(x), do: not just?(x)
end

defimpl String.Chars, for: ADT.Maybe do
  def to_string(%ADT.Maybe{maybe: maybe}) do
    case maybe do
      nil -> "Nothing"
      x   -> "Just #{ x }"
    end
  end
end

defimpl Inspect, for: ADT.Maybe do
  def inspect(t, _), do: "#<Maybe: #{ t }>"
end
