defmodule Witchcraft.Functor.Operator do
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
