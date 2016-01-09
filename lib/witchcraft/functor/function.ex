defmodule Witchcraft.Functor.Function do
  @moduledoc ~S"""
  """

  import Witchcraft.Functor, only: [lift: 2]

  @spec lift((... -> any)) :: (any -> any)
  def lift(fun), do: &lift(&1, fun)

  @doc ~S"""
  Replace all of the input's data nodes with some constant value

      iex> Witchcraft.Functor.Functions.map_replace([1,2,3], 42)
      [42, 42, 42]

  """
  @spec map_replace(any, any) :: any
  def map_replace(a, constant), do: a |> lift &Quark.const(&1, constant)
end
