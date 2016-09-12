defmodule Witchcraft.Applicative.Function do
  @moduledoc ~S"""
  Function helpers, derivatives and operators for
  `Witchcraft.Applicative.Protocol`
  """

  import Witchcraft.Applicative.Protocol

  use Quark
  use Witchcraft.Functor

  @type applicative :: any

  def rewrap(pre_wrapped), do: wrap(pre_wrapped, pre_wrapped)

  @doc ~S"""
  `lift` a function over 2 arguments

  ## Examples

      iex> lift([1,2,3], [4,5,6], &(&1 + &2))
      [5,6,7,6,7,8,7,8,9]

  """
  @spec lift(applicative, applicative, fun) :: applicative
  def lift(val_1, val_2, fun), do: seq(val_2, lift(val_1, curry(fun)))

  @doc ~S"""
  `lift` a function over 3 arguments

  ## Examples

      iex> lift([1,2], [3,4], [5,6], &(&1 + &2 + &3))
      [9,10,10,11,10,11,11,12]

  """
  @spec lift(applicative, applicative, fun) :: applicative
  def lift(val_1, val_2, val_3, fun) do
    seq(val_3, lift(val_1, val_2, fun))
  end

  @doc ~S"""
  `lift` a function over 4 arguments

  ## Examples

      iex> lift([1,2], [3,4], [5,6], [7,8], &(&1 + &2 + &3 + &4))
      [16,17,17,18,17,18,18,19,17,18,18,19,18,19,19,20]

  """
  @spec lift(applicative, applicative, applicative, fun) :: applicative
  def lift(val_1, val_2, val_3, val_4, fun) do
    seq(val_4, lift(val_1, val_2, val_3, fun))
  end

  @doc ~S"""
  Sequentially `seq`, and discard the second value of each pair.
  """
  @spec seq_first(applicative, applicative) :: any
  def seq_first(first, second), do: [first, second] |> lift(&constant/2)

  @doc ~S"""
  Sequentially `seq`, and discard the first value of each pair.
  """
  @spec seq_second(applicative, applicative) :: any
  def seq_second(first, second) do
    [first, second] |> lift(fn x -> constant(x, &id/1) end)
  end
end
