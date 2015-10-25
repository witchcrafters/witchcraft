defmodule Witchcraft.Functor.Functions do
  alias Witchcraft.Functor, as: F
  alias Witchcraft.Utils, as: U

  @type a  :: any
  @type fa :: any
  @type fb :: any

  @spec map_replace(a, fa) :: fb
  def map_replace(a, fa) do
    a |> U.const |> F.lift(fa)
  end

  @doc "Alias for fmap with arguments flipped ('map over')"
  def func <~ args, do: F.lift(args, func)

  @doc "Alias for fmap"
  def args ~> func, do: F.lift(args, func)
end
