defmodule Witchcraft.Category.FunctionBench do
  use Benchfella
  use Witchcraft.Category

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  def f(x), do: "#{inspect x}/#{inspect x}"

  ################
  # Semigroupoid #
  ################

  bench "identity/1", do: identity(&f/1)

end
