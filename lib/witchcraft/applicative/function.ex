defmodule Witchcraft.Applicative.Function do
  @moduledoc ~S"""
  Function helpers, derivatives and operators for `Witchcraft.Applicative`
  """

  import Kernel, except: [apply: 2]

  import Quark, only: [flip: 1]
  import Quark.Curry, only: [curry: 1]

  import Witchcraft.Applicative, only: [apply: 2]
  import Witchcraft.Functor.Operator, only: [<~: 2, ~>: 2]

  @doc ~S"""
  `lift` a function that takes a list of arguments

  ```elixir

  iex> lift([[1,2,3], [4,5,6]], &(&1 + &2))
  [5,6,7,6,7,8,7,8,9]

  iex> lift([[1,2], [3,4], [5,6]], &(&1 + &2 + &3))
  [9,10,10,11,10,11,11,12]

  iex> lift([[1,2], [3,4], [5,6], [7,8]], &(&1 + &2 + &3 + &4))
  [16,17,17,18,17,18,18,19,17,18,18,19,18,19,19,20]

  ```

  """
  @spec lift(any, (... -> any)) :: any
  def lift([value], fun), do: value ~> curry(fun)
  def lift([head|tail], fun), do: Enum.reduce(tail, lift([head], fun), &apply/2)
end
