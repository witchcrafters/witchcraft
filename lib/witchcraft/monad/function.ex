defmodule Witchcraft.Monad.Function do
  @moduledoc ~S"""
  """

  import Witchcraft.Functor, only: [lift: 2]
  import Witchcraft.Monad, only: [join: 1]

  @doc ~S"""
  """
  @spec bind(any, fun) :: any
  def bind(data, fun), do: lift(data, fun) |> join
end
