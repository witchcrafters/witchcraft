defmodule Witchcraft.Applicative.Functions do
  @moduledoc ~S"""
  Function helpers, derivatives and operators for `Witchcraft.Applicative`
  """

  alias Witchcraft.Functor
  alias Witchcraft.Applicative, as: A
  alias Witchcraft.Utility, as: U

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
  def lift([value|[]], func), do: F.lift(value, func)
  def lift([head|tail], func) do
    lifted = U.curry(func) ~> head
    Enum.reduce(tail, lifted, U.flip(apply))
  end

  @doc ~S"""
  Infix alias for `Witchcraft.Applicative.apply`

      iex> [1,2,3] <<~ [&(&1 + 1), &(&1 * 10)]
      [2,3,4,10,20,30]

  """
  @spec any <<~ (any -> any) :: any
  def value <<~ func, do: apply(value, func)

  @doc ~S"""
  Infix alias for `Witchcraft.Applicative.apply`, with arguments reversed.
  This allows for easier reading in an classic "appicative style".

      iex> [&(&1 + 1), &(&1 * 10)] ~>> [1,2,3]
      [2,3,4,10,20,30]

  """
  @spec (any -> any) ~>> any :: any
  def func ~>> value, do: value <<~ func

  @doc ~S"""
  Operator alias for `wrap`, punning on `@spec`'s `::`.

      iex> 1 ::: []
      [1]

      iex> "cool story, bro" ::: %U.Id{}
      %U.Id{id: "cool story, bro"}

  """
  @spec any ::: any :: any
  def bare ::: target, do: wrap(target, bare)
end
