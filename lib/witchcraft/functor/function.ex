defmodule Witchcraft.Functor.Function do
  @moduledoc "Functions that come directly from `lift`"

  import Witchcraft.Functor.Protocol
  use Quark

  @doc ~S"""
  Not strictly a curried version of `lift/2`. `lift/1` partially applies a function,
  to create a "lifted" version of that function.

  ## Examples

      iex> x10 = &lift(fn x -> x * 10 end).(&1)
      ...> [1,2,3] |> x10.()
      [10,20,30]

      # iex> x10 = &lift(fn x -> x * 10 end).(&1)
      # ...> %Algae.Id{id: 13} |> x10.()
      # %Algae.Id{id: 130}

  """
  @spec lift(fun) :: (any -> any)
  defpartial lift(fun), do: &lift(&1, curry(fun))

  @doc ~S"""
  Replace all of the input's data nodes with some constant value

  ## Examples

      iex> [1,2,3] |> replace(42)
      [42, 42, 42]

  """
  @spec replace(any, any) :: any
  def replace(data, const), do: data |> lift(&constant(const, &1))
end
