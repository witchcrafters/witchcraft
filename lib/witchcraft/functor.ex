defprotocol Witchcraft.Functor do
  @moduledoc ~S"""
  Functors provide a way to apply a function to every element in a collection
  (lists, trees, etc).

  All elements of the collection being mapped over need to be consumable by
  the mapping function. The simplest way to handle this is to have only one
  type in the collection.

  # Properties
  ## Identity
  Mapping the identity function over the object returns the same object
  ex. `fmap([1,2,3], &(&1)) == [1,2,3]`

  ## Distributivity
  `fmap(coll, (f |> g)) == coll |> fmap f |> fmap g`

  # Notes:
  - The argument order convention is reversed from most other lanaguges
  - Most (if not all) implimentations of `fmap` should be
    expressable in terms of [`Enum.reduce/3`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#reduce/3)
  - Falls back to [`Enum.map/2`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#map/2)
  """

  @fallback_to_any true

  @doc """
  Apply a function to every element in a collection, tree, or other structure.
  The collection will retain its structure (list, tree, and so on).
  """
  @spec fmap(any, (any -> any)) :: any
  def fmap(collection, function)
end

defimpl Witchcraft.Functor, for: Any do
  def fmap(coll, func), do: Enum.map(coll, func)
end
