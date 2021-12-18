defmodule Witchcraft.Setoid.FloatBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Setoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @float_a 10.7218
  @float_b -45.21

  ##########
  # Kernel #
  ##########

  bench "Kernel.==/2", do: Kernel.==(@float_a, @float_b)
  bench "Kernel.!=/2", do: Kernel.!=(@float_a, @float_b)

  ##########
  # Setoid #
  ##########

  bench "equivalent?/2",    do: equivalent?(@float_a, @float_b)
  bench "nonequivalent?/2", do: nonequivalent?(@float_a, @float_b)

  # --------- #
  # Operators #
  # --------- #

  bench "==/2", do: @float_a == @float_b
  bench "!=/2", do: @float_a != @float_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_float_a 1_234_567.890
  @big_float_b 9_876.543210

  bench "$$$ Kernel.==/2", do: Kernel.==(@big_float_a, @big_float_b)
  bench "$$$ Kernel.!=/2", do: Kernel.!=(@big_float_a, @big_float_b)

  bench "$$$ ==/2", do: @big_float_a == @big_float_b
  bench "$$$ !=/2", do: @big_float_a != @big_float_b
end
