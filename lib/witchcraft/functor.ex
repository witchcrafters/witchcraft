defmodule Witchcraft.Functor do
  # This is probably just the existing Enumerable
  @doc """
  Functors provide a way to apply a function to every element in a collection
  (lists, trees, etc). For lists, this is just map.

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

  use Behaviour
  # @behaviour Witchcraft.Monoid

  defcallback fmap :: a -> b
end
