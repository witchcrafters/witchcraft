defmodule Witchcraft.Monoid.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple 0..10 |> Enum.to_list() |> List.to_tuple()

  ##########
  # Monoid #
  ##########

  bench "empty/1",  do: empty(@tuple)
  bench "empty?/1", do: empty?(@tuple)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_tuple 0..100_000 |> Enum.to_list() |> List.to_tuple()

  bench "$$$ empty/1",  do: empty(@big_tuple)
  bench "$$$ empty?/1", do: empty?(@big_tuple)

end
