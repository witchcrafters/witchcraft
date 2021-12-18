defmodule Witchcraft.Semigroup.MapSetBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Semigroup

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @map_set_a MapSet.new(1..100)
  @map_set_b MapSet.new(9..99)

  ##########
  # MapSet #
  ##########

  bench("MapSet.union/2", do: MapSet.union(@map_set_a, @map_set_b))

  #############
  # Semigroup #
  #############

  bench("append/2", do: append(@map_set_a, @map_set_b))
  bench("repeat/2", do: repeat(@map_set_a, times: 100))

  # --------- #
  # Operators #
  # --------- #

  bench("<>/2", do: @map_set_a <> @map_set_b)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_map_set_a MapSet.new(0..1_000)
  @big_map_set_b MapSet.new(99..999)

  bench("$$$ MapSet.union/2", do: MapSet.union(@big_map_set_a, @big_map_set_b))
  bench("$$$ append/2", do: append(@big_map_set_a, @big_map_set_b))
  bench("$$$ <>/2", do: @big_map_set_a <> @big_map_set_b)
end
