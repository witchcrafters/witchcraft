defprotocol Witchcraft.Functor do
  # This is probably just the existing Enumerable
  @moduledoc """
  Functors provide a way to apply a function to every element in a collection
  (lists, trees, etc). For example, the fmap/2 for lists is Enum.map/2.

  All elements of the collection being mapped over need to be consumable by
  the mapping function. The simplest way to handle this is to have only one
  type in the collection.

  Functor Properties:
  1. Identity
  Mapping the identity function over the object returns the same object
  ex. fmap([1,2,3], &(&1)) == [1,2,3]

  2. Distributivity
  fmap coll (f |> g) == coll |> fmap f |> fmap g

  Notes:
  - The argument order convention is reversed from most other lanaguges
  - All implimentations of fmap should be expressable in terms of Enum.reduce/2
  """

  @doc """
  Apply a function to every element in a collection, tree, or other structure.
  The collection will retain it's structure (list, tree, and so on).
  """
  @spec fmap(any, (any -> any)) :: any
  def fmap(collection, function)
end
