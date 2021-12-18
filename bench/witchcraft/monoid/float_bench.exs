defmodule Witchcraft.Monoid.FloatBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @float 10.7289

  ##########
  # Monoid #
  ##########

  bench "empty/1",  do: empty(@float)
  bench "empty?/1", do: empty?(@float)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_float 1_234_567_890.21347289

  bench "$$$ empty/1",  do: empty(@float)
  bench "$$$ empty?/1", do: empty?(@float)

end
