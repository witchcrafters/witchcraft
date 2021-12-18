defmodule Witchcraft.Semigroup.MapBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Semigroup

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

  #######
  # Map #
  #######

  bench("Map.merge/2", do: Map.merge(@map_a, @map_b))

  #############
  # Semigroup #
  #############

  bench("append/2", do: append(@map_a, @map_b))
  bench("repeat/2", do: repeat(@map_a, times: 100))

  # --------- #
  # Operators #
  # --------- #

  bench("<>/2", do: @map_a <> @map_b)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..100_000 |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999_999 |> Enum.to_list() |> Enum.shuffle()

  @big_map_a @big_list_a |> Enum.zip(@list_b) |> Enum.into(%{})
  @big_map_b @big_list_b |> Enum.zip(@list_a) |> Enum.into(%{})

  bench("$$$ Map.merge/2", do: Map.merge(@big_map_a, @big_map_b))
  bench("$$$ append/2", do: append(@big_map_a, @big_map_b))
  bench("$$$ <>/2", do: @big_map_a <> @big_map_b)
end
