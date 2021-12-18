defmodule Witchcraft.Semigroup.FloatBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Semigroup

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @float_a 10.232132171
  @float_b -45.372189

  ##########
  # Kernel #
  ##########

  bench("Kernel.+/2", do: @float_a + @float_b)

  #############
  # Semigroup #
  #############

  bench("append/2", do: append(@float_a, @float_b))
  bench("repeat/2", do: repeat(@float_a, times: 100))

  # --------- #
  # Operators #
  # --------- #

  bench("<>/2", do: @float_a <> @float_b)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_float_a 1_234_567.890
  @big_float_b 9_876.6543210

  bench("$$$ Kernel.+/2", do: @big_float_a + @big_float_b)
  bench("$$$ append/2", do: append(@big_float_a, @big_float_b))
  bench("$$$ <>/2", do: @big_float_a <> @big_float_b)
end
