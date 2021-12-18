defmodule Witchcraft.Setoid.IntegerBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Setoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @int_a 10
  @int_b -45

  ##########
  # Kernel #
  ##########

  bench "Kernel.==/2", do: Kernel.==(@int_a, @int_b)
  bench "Kernel.!=/2", do: Kernel.!=(@int_a, @int_b)

  ##########
  # Setoid #
  ##########

  bench "equivalent?/2",    do: equivalent?(@int_a, @int_b)
  bench "nonequivalent?/2", do: nonequivalent?(@int_a, @int_b)

  # --------- #
  # Operators #
  # --------- #

  bench "==/2", do: @int_a == @int_b
  bench "!=/2", do: @int_a != @int_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_int_a 1_234_567_890
  @big_int_b 9_876_543_210

  bench "$$$ Kernel.==/2", do: Kernel.==(@big_int_a, @big_int_b)
  bench "$$$ Kernel.!=/2", do: Kernel.!=(@big_int_a, @big_int_b)

  bench "$$$ ==/2", do: @big_int_a == @big_int_b
  bench "$$$ !=/2", do: @big_int_a != @big_int_b
end
