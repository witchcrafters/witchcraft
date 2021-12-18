defmodule Witchcraft.Setoid.MapSetBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Setoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @map_set_a MapSet.new(1..100)
  @map_set_b MapSet.new(9..99)

  ##########
  # Kernel #
  ##########

  bench "Kernel.==/2", do: Kernel.==(@map_set_a, @map_set_b)
  bench "Kernel.!=/2", do: Kernel.!=(@map_set_a, @map_set_b)

  ##########
  # Setoid #
  ##########

  bench "equivalent?/2",    do: equivalent?(@map_set_a, @map_set_b)
  bench "nonequivalent?/2", do: nonequivalent?(@map_set_a, @map_set_b)

  # --------- #
  # Operators #
  # --------- #

  bench "==/2", do: @map_set_a == @map_set_b
  bench "!=/2", do: @map_set_a != @map_set_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_map_set_a MapSet.new(0..1_000)
  @big_map_set_b MapSet.new(99..999)

  bench "$$$ Kernel.==/2", do: Kernel.==(@big_map_set_a, @big_map_set_b)
  bench "$$$ Kernel.!=/2", do: Kernel.!=(@big_map_set_a, @big_map_set_b)

  bench "$$$ ==/2", do: @big_map_set_a == @big_map_set_b
  bench "$$$ !=/2", do: @big_map_set_a != @big_map_set_b
end
