defmodule Witchcraft.Ord.FloatBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Ord

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @float_a 10.7218
  @float_b -45.09271

  ##########
  # Kernel #
  ##########

  bench("Kernel.>/2", do: Kernel.>(@float_a, @float_b))
  bench("Kernel.</2", do: Kernel.<(@float_a, @float_b))

  bench("Kernel.>=/2", do: Kernel.>=(@float_a, @float_b))
  bench("Kernel.<=/2", do: Kernel.<=(@float_a, @float_b))

  #######
  # Ord #
  #######

  bench("compare/2", do: compare(@float_a, @float_b))

  bench("equal?/2", do: equal?(@float_a, @float_b))
  bench("greater?/2", do: greater?(@float_a, @float_b))
  bench("lesser/2", do: lesser?(@float_a, @float_b))

  # --------- #
  # Operators #
  # --------- #

  bench(">/2", do: @float_a > @float_b)
  bench("</2", do: @float_a < @float_b)

  bench(">=/2", do: @float_a >= @float_b)
  bench("<=/2", do: @float_a <= @float_b)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_float_a 1_234_567.890
  @big_float_b 9_876.543210

  bench("$$$ Kernel.>/2", do: Kernel.>(@big_float_a, @big_float_b))
  bench("$$$ Kernel.</2", do: Kernel.<(@big_float_a, @big_float_b))

  bench("$$$ </2", do: @big_float_a < @big_float_b)
  bench("$$$ >/2", do: @big_float_a > @big_float_b)
end
