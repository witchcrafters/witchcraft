defmodule Witchcraft.Functor.Operator do
  import Witchcraft.Functor, only: [lift: 2]

  @doc ~S"""
  Alias for `lift` with arguments flipped ('map over')

  ```elixir

  iex> (&(&1 * 10)) ~> [1,2,3]
  [10, 20, 30]

  ```

  """
  @spec (any -> any) ~> any :: any
  def func ~> args, do: lift(args, func)

  @doc ~S"""
  Alias for `lift`

  ```elixir

  iex> [1,2,3] <~ &(&1 * 10)
  [10, 20, 30]

  ```

  """
  @spec any <~ (any -> any) :: any
  def args <~ func, do: func ~> args
end
