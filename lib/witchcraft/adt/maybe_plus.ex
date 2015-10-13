defmodule ADT.MaybePlus do
  @moduledoc ~S"""
  `MaybePlus` encapulates the idea of a value that might not be there.
  This is often a failed computation, but in some cases an empty value may be
  the expected behaviour.

  Much like `%Maybe{}`, a `%MaybePlus{}` value can either be `Just some_value`,
  or `Nothing`, but with error reason tracking intact.

  More typical of Elixir is to use `{:ok, some_value}`, or `{:error, some_reason}`.
  By contrast, `%MaybePlus{}` has an implied `:ok`, if there is a value in the
  `maybe` key.

  The additional `meta` key exists to track error reasons, but may be used
  for general purpose metadata (including success messaging). This has the
  potential to enter an inconsitent state, where the `maybe` and `meta` values
  come out of sync. It is recommended to *always* set both values when updating
  the struct.
  """

  defstruct maybe: nil, meta: nil

  @type maybe_plus(a, b) :: %ADT.MaybePlus{maybe: a, meta: b}

  @spec from_status_tuple({atom, any}) :: maybe_plus(any, any)
  def from_status_tuple({:ok,    payload}), do: %ADT.MaybePlus{maybe: payload}
  def from_status_tuple({:error, reason}),  do: %ADT.MaybePlus{meta:  reason}

  @spec just?(maybe_plus(any, any)) :: boolean
  def just?(%ADT.MaybePlus{maybe: maybe}), do: !!maybe

  @spec nothing?(maybe_plus(any, any)) :: boolean
  def nothing?(x), do: not just?(x)

  def meta(%ADT.MaybePlus{meta: meta}), do: meta
end

defimpl String.Chars, for: ADT.MaybePlus do
  def to_string(%ADT.MaybePlus{maybe: maybe, meta: meta}) do
    clean_meta = meta || 'nil'
    case maybe do
      nil -> "{Nothing, meta: #{ clean_meta }}"
      x   -> "{Just #{ x }, meta: #{ clean_meta }}"
    end
  end
end

defimpl Inspect, for: ADT.MaybePlus do
  def inspect(t, _), do: "#<MaybePlus: #{ t }>"
end
