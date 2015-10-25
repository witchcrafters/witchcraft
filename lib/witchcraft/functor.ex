defprotocol Witchcraft.Functor do
  @moduledoc ~S"""
  Functors provide a way to apply a function to every element in a datatype
  (lists, trees, etc).

  All elements of the data being mapped over need to be consumable by
  the mapping function. The simplest way to handle this is to have only one
  type in the data/collection.

  # Properties
  ## Identity
  Mapping the identity function over the object returns the same object
  ex. `lift([1,2,3], &(&1)) == [1,2,3]`

  ## Distributive
  `lift(data, (f |> g)) == data |> lift f |> lift g`

  # Notes:
  - The argument order convention is reversed from most other lanaguges
  - Most (if not all) implimentations of `lift` should be
    expressable in terms of [`Enum.reduce/3`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#reduce/3)
  - Falls back to [`Enum.map/2`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#map/2)
  """

  @fallback_to_any true

  @type a  :: any
  @type wa :: any
  @type r  :: any
  @type wr :: any

  @doc """
  Apply a function to every element in some collection, tree, or other structure.
  The collection will retain its structure (list, tree, and so on).
  """
  @spec lift(wa, (a -> r)) :: wr
  def lift(data, function)
end

defimpl Witchcraft.Functor, for: Any do
  def lift(data, func), do: Enum.map(data, func)
end
