defmodule Witchcraft.Semigroup.FunctionBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Semigroup

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

  ##########
  # Kernel #
  ##########

  bench "naive compose function" do
    fn(f, g) ->
      fn x -> x |> f.() |> g.() end
    end.(&fun/1, &twice/1)
  end

  #############
  # Semigroup #
  #############

  bench "append/2", do: append(&fun/1, &twice/1)
  bench "repeat/2", do: repeat(&fun/1, times: 100)

  # --------- #
  # Operators #
  # --------- #

  bench "<>/2", do: (&fun/1) <> (&twice/1)

end
