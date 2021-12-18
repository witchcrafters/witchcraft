defmodule Witchcraft.Setoid.MapBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Setoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list_a 11..100 |> Enum.to_list() |> Enum.shuffle()
  @list_b 99..999 |> Enum.to_list() |> Enum.shuffle()

  @map_a @list_a |> Enum.zip(@list_b) |> Enum.into(%{})
  @map_b @list_b |> Enum.zip(@list_a) |> Enum.into(%{})

  ##########
  # Kernel #
  ##########

  bench "Kernel.==/2", do: Kernel.==(@map_a, @map_b)
  bench "Kernel.!=/2", do: Kernel.!=(@map_a, @map_b)

  ##########
  # Setoid #
  ##########

  bench "equivalent?/2",    do: equivalent?(@map_a, @map_b)
  bench "nonequivalent?/2", do: nonequivalent?(@map_a, @map_b)

  # --------- #
  # Operators #
  # --------- #

  bench "==/2", do: @map_a == @map_b
  bench "!=/2", do: @map_a != @map_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..100_000  |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999_999 |> Enum.to_list() |> Enum.shuffle()

  @big_map_a @big_list_a |> Enum.zip(@list_b) |> Enum.into(%{})
  @big_map_b @big_list_b |> Enum.zip(@list_a) |> Enum.into(%{})

  bench "$$$ Kernel.==/2", do: Kernel.==(@big_map_a, @big_map_b)
  bench "$$$ Kernel.!=/2", do: Kernel.!=(@big_map_a, @big_map_b)

  bench "$$$ ==/2", do: @big_map_a == @big_map_b
  bench "$$$ !=/2", do: @big_map_a != @big_map_b
end
