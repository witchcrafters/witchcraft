defmodule Witchcraft.Applicative.Function do
  @moduledoc ~S"""
  Function helpers, derivatives and operators for `Witchcraft.Applicative`
  """

  import Witchcraft.Functor.Operator

  @doc ~S"""
  `lift` a function that takes a list of arguments

      iex> lift([1,2,3], [4,5,6], &(&1 + &2))
      [5,6,7,6,7,8,7,8,9]

      iex> lift([1,2], [3,4], [5,6], &(&1 + &2 + &3))
      [9,10,10,11,10,11,11,12]

      iex> lift([1,2], [3,4], [5,6], [7,8], &(&1 + &2 + &3 + &4))
      [16,17,17,18,17,18,18,19,17,18,18,19,18,19,19,20]

  """
  @spec lift([any], (... -> a)) :: any
  def lift([value|[]], func), do: value <~ func

  def lift([head|tail], func) do
    lifted = Quark.Curry.curry(func) ~> head
    Enum.reduce(tail, lifted, Quark.flip(apply))
  end
end
