defmodule Witchcraft.Monad.Operator do
  @doc ~S"""
  Alias for `bind`

  ```elixir

  iex> [1,2,3] >>> &(wrap(&1 * 1))
  [10, 20, 30]

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
end
