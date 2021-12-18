defmodule Witchcraft.Monoid.MapSetBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @map_set MapSet.new(0..10)

  ##########
  # Monoid #
  ##########

  bench("empty/1", do: empty(@map_set))
  bench("empty?/1", do: empty?(@map_set))

  # ---------- #
  # Large Data #
  # ---------- #

  @big_map_set MapSet.new(0..100_000)

  bench("$$$ empty/1", do: empty(@big_map_set))
  bench("$$$ empty?/1", do: empty?(@big_map_set))
end
