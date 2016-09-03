defmodule Witchcraft.Functor do
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

  ## Properties
  ### Identity
  Mapping the identity function over the object returns the same object
  ex. `lift([1,2,3], id) == [1,2,3]`

  ### Distributive
  `lift(data, (f |> g)) == data |> lift(f) |> lift(g)`

  ### Associates all objects
  Mapping a function onto an object returns a value.
  ie: does not throw an error, returns a value of the target type (not of
  the wrong type, or the type `none`)

  ## Notes:
  - The argument order convention is reversed from most other lanaguges
  - Most (if not all) implimentations of `lift` should be
    expressable in terms of [`Enum.reduce/3`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#reduce/3)
  - Falls back to [`Enum.map/2`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#map/2)

  ## Examples

      iex> [1,2,3] |> lift(&(&1 + 1))
      [2,3,4]

      iex> defimpl Witchcraft.Functor, for: Algae.Id do
      iex>   def lift(%Algae.Id{id: inner}, func), do: %Algae.Id{id: func.(inner)}
      iex> end
      iex> lift(%Algae.Id{id: 1}, &(&1 + 1))
      %Algae.Id{id: 2}

  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defdelegate lift(data, fun), to: Witchcraft.Functor.Protocol
  defdelegate lift(fun),        to: Witchcraft.Functor.Function
  defdelegate lift(),           to: Witchcraft.Functor.Function

  defdelegate replace(data, const), to: Witchcraft.Functor.Function

  defdelegate data ~> func, to: Witcraft.Functor.Operator
  defdelegate func <~ data, to: Witcraft.Functor.Operator
end
