defmodule Witchcraft.Monad.Operator do
  @doc ~S"""
  Alias for `bind`

  ```elixir

  iex> [1,2,3] >>> &(wrap(&1 * 1))
  [10, 20, 30]

  iex> [1,2,3] >>> fn x -> [x+1] >>> fn y -> [y*x, y*10, x-1] end end
  [2,20,0,6,30,1,12,40,2]

  """
  @spec any >>> ((any, any) -> any) :: any
  def wrapped >>> fun, do: Witchcraft.Monad.Function.bind(wrapped, fun)

  @doc ~S"""
  Alias for `bind`

  ```elixir

  iex> &(wrap(&1 * 1)) <<< [1,2,3]
  [10, 20, 30]

  """
  @spec ((any, any) -> any) <<< any :: any
  def fun <<< wrapped, do: wrapped >>> fun

  @doc ~S"""
  """
  @spec fun <~> fun :: fun
  def bind_a <~> bind_b, do: Witchcraft.Monad.Function.compose(bind_a, bind_b)
end
