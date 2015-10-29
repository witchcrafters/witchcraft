defprotocol Witchcraft.Functor do
  require Witchcraft.Utility.Id
  @moduledoc ~S"""
  Functors provide a way to apply a function to value(s) a datatype
  (lists, trees, maybes, etc).

  All elements of the data being mapped over need to be consumable by
  the lifted function. The simplest way to handle this is to have only one
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

  ## Associates all objects
  Mapping a function onto an object returns a value.
  ie: does not throw an error, returns a value of the target type (not of
  the wrong type, or the type `none`)

  # Notes:
  - The argument order convention is reversed from most other lanaguges
  - Most (if not all) implimentations of `lift` should be
    expressable in terms of [`Enum.reduce/3`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#reduce/3)
  - Falls back to [`Enum.map/2`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#map/2)

  # Examples

  ```

  iex> Witchcraft.Functor.lift([1,2,3], &(&1 + 1))
  [2,3,4]

  iex> defimpl Witchcraft.Functor, for: Witchcraft.Utility.Id do
  iex>   def lift(%Witchcraft.Utility.Id{id: inner}, func), do: %Witchcraft.Utility.Id{id: func.(inner)}
  iex> end
  iex> Witchcraft.Functor.lift(%Witchcraft.Utility.Id{id: 1}, &(&1 + 1))
  %Witchcraft.Utility.Id{id: 2}

  ```
  """

  @fallback_to_any true

  @doc """
  Apply a function to every element in some collection, tree, or other structure.
  The collection will retain its structure (list, tree, and so on).
  """
  @spec lift(any, (any -> any)) :: any
  def lift(data, function)
end

defimpl Witchcraft.Functor, for: Any do
  @doc "Default implementation of `Functor` is `Enum.map`"
  def lift(data, func), do: Enum.map(data, func)
end

defimpl Witchcraft.Functor, for: Witchcraft.Utility.Id do
  @doc "Example struct implimentation"
  def lift(%Witchcraft.Utility.Id{id: data}, func), do: %Witchcraft.Utility.Id{id: func.(data)}
end
