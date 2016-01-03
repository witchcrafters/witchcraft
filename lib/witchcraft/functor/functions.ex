defmodule Witchcraft.Functor.Functions do
  @moduledoc ~S"""
  """

  alias Quark, as: Q
  alias Witchcraft.Functor, as: F

  @spec lift((... -> any)) :: (any -> any)
  def lift(fun), do: &lift(&1, fun)

  @doc ~S"""
  Replace all of the input's data nodes with some constant value

      iex> Witchcraft.Functor.Functions.map_replace([1,2,3], 42)
      [42, 42, 42]

  """
  @spec map_replace(any, any) :: any
  def map_replace(a, constant) do
    F.lift(a, &(Q.const(&1, constant)))
  end

  @doc ~S"""
  Alias for `lift` with arguments flipped ('map over')

      iex> (&(&1 * 10)) ~> [1,2,3]
      [10, 20, 30]

  """
  @spec (any -> any) ~> any :: any
  def func ~> args, do: F.lift(args, func)

  @doc ~S"""
  Alias for `lift`

      iex> [1,2,3] <~ &(&1 * 10)
      [10, 20, 30]

  """
  @spec any <~ (any -> any) :: any
  def args <~ func, do: func ~> args
end
