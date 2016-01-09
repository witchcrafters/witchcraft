defmodule Witchcraft.Applicative.Operator do
  @doc ~S"""
  Infix alias for `Witchcraft.Applicative.apply`

  iex> [1,2,3] <<~ [&(&1 + 1), &(&1 * 10)]
  [2,3,4,10,20,30]

  """
  @spec any <<~ (any -> any) :: any
  def value <<~ func, do: Witchcraft.Applicative.apply(value, func)

  @doc ~S"""
  Infix alias for `Witchcraft.Applicative.apply`, with arguments reversed.
  This allows for easier reading in an classic "appicative style".

  iex> [&(&1 + 1), &(&1 * 10)] ~>> [1,2,3]
  [2,3,4,10,20,30]

  """
  @spec (any -> any) ~>> any :: any
  def func ~>> value, do: value <<~ func
end
