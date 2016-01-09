defmodule Witchcraft.Applicative.Operator do
  @moduledoc ~S"""
  """

  import Kernel, except: [apply: 2]
  import Witchcraft.Applicative, only: [apply: 2]

  @doc ~S"""
  Infix alias for `Witchcraft.Applicative.apply`

  ```elixir

  iex>
  iex> [1,2,3] <<~ [&(&1 + 1), &(&1 * 10)]
  [2,3,4,10,20,30]

  ```

  """
  @spec any <<~ (any -> any) :: any
  def value <<~ func, do: apply(value, func)

  @doc ~S"""
  Infix alias for `Witchcraft.Applicative.apply`, with arguments reversed.
  This allows for easier reading in an classic "appicative style".

  ```elixir

  iex> [&(&1 + 1), &(&1 * 10)] ~>> [1,2,3]
  [2,3,4,10,20,30]

  ```

  """
  @spec (any -> any) ~>> any :: any
  def func ~>> value, do: value <<~ func
end
