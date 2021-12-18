defmodule Witchcraft.Applicative.FunctionBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Applicative

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  def fun(x), do: "#{inspect x}-#{inspect x}"

  # -------------- #
  # Test Functions #
  # -------------- #

  defp twice(f), do: fn x -> x |> f.() |> f.() end
  defp to_fun(x), do: of(&fun/1).(x)

  ###############
  # Applicative #
  ###############

  bench "of/1", do: to_fun(42)
  bench "of/2", do: of(&fun/1, &twice/1)

end
