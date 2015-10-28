defprotocol Witchcraft.Functor do
  @moduledoc ~S"""
  Functors provide a way to apply a function to value(s) a datatype
  (lists, trees, maybes, etc).

  All elements of the data being mapped over need to be consumable by
  the mapping function. The simplest way to handle this is to have only one
  type in the data/collection.

  The term `lift` is used rather than the more common `map`.
  First, this makes clear that the use is to lift functions into containers.
  Second, if you want mapping behaviour on collections, check out
  [`Enum.map`](http://elixir-lang.org/docs/v1.1/elixir/Enum.html#map/2).
  In fact, the default implimentation *is* `Enum.map`, so you can use this with the
  build-in datatypes.
  Third, the naming becomes more consistent with
  [`Applicative`](http://www.robotoverlord.io/witchcraft/Witchcraft.Applicative.Functions.html)'s
  `lift2`, `lift3`, and so on.

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

  # Examples
  ```

  iex> Witchcraft.Functor.lift([1,2,3], &(&1 + 1))
  [2,3,4]

  iex> defmodule Foo do
  iex>   defstruct inner: 1
  iex> end
  iex> defimpl Witchcraft.Functor, for: Foo do
  iex>   def lift(%Foo{inner: inner}, func), do: %Foo{value: func(inner)}
  iex> end
  iex> Witchcraft.Functor.lift(%Foo{}, &(&1 + 1))
  %Foo{value: 2}

  ```
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
