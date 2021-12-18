defmodule Witchcraft.Semigroup.IntegerBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Semigroup

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

  bench "Kernel.+/2", do: @int_a + @int_b

  #############
  # Semigroup #
  #############

  bench "append/2", do: append(@int_a, @int_b)
  bench "repeat/2", do: repeat(@int_a, times: 100)

  # --------- #
  # Operators #
  # --------- #

  bench "<>/2", do: @int_a <> @int_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_int_a 1_234_567_890
  @big_int_b 9_876_543_210

  bench "$$$ Kernel.+/2", do: @big_int_a + @big_int_b
  bench "$$$ append/2",   do: append(@big_int_a, @big_int_b)
  bench "$$$ <>/2",       do: @big_int_a <> @big_int_b

end
