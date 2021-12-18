defmodule Witchcraft.Monoid.FunctionBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @fun &Witchcraft.Comonad.extract/1

  ##########
  # Monoid #
  ##########

  bench("empty/1", do: empty(@fun))
  bench("empty?/1", do: empty?(@fun))
end
