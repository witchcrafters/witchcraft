defmodule Witchcraft.Monoid.IntegerBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @int 10

  ##########
  # Monoid #
  ##########

  bench("empty/1", do: empty(@int))
  bench("empty?/1", do: empty?(@int))

  # ---------- #
  # Large Data #
  # ---------- #

  @big_int 1_234_567_890

  bench("$$$ empty/1", do: empty(@int))
  bench("$$$ empty?/1", do: empty?(@int))
end
