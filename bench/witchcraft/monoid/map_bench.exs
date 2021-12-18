defmodule Witchcraft.Monoid.MapBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list 0..10 |> Enum.to_list()
  @map  @list |> Enum.zip(@list) |> Enum.into(%{})

  ##########
  # Monoid #
  ##########

  bench "empty/1",  do: empty(@map)
  bench "empty?/1", do: empty?(@map)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list 0..100_000 |> Enum.to_list()
  @big_map  @big_list |> Enum.zip(@big_list) |> Enum.into(%{})

  bench "$$$ empty/1",  do: empty(@big_map)
  bench "$$$ empty?/1", do: empty?(@big_map)

end
