defmodule Witchcraft.Monad.Operator do
  @moduledoc "Operator aliases for `Witchcraft.Monad`"

  @doc ~S"""
  Operator alias for `bind`

  ## Examples

      iex> use Witchcraft.Applicative
      ...> [1,2,3] >>> fn x -> [x * 10] end
      [10, 20, 30]

      iex> [1,2,3] >>> fn x ->
      ...>   [x+1] >>> fn y ->
      ...>     [y*x, y*10, x-1]
      ...>   end
      ...> end
      [2,20,0,6,30,1,12,40,2]

  """
  @spec any >>> ((any, any) -> any) :: any
  def wrapped >>> fun, do: Witchcraft.Monad.Function.bind(wrapped, fun)

  @doc ~S"""
  Operator alias for `bind`, with arguments reversed

  ## Examples

      iex> use Witchcraft.Applicative
      ...> fn x -> [x * 10] end <<< [1,2,3]
      [10, 20, 30]

  """
  @spec ((any, any) -> any) <<< any :: any
  def fun <<< wrapped, do: wrapped >>> fun

  @doc ~S"""
  """
  @spec fun <~> fun :: fun
  def bind_a <~> bind_b, do: Witchcraft.Monad.Function.compose(bind_a, bind_b)
end
