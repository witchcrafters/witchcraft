defmodule Witchcraft.Semigroup.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Semigroup

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple_a 11..100 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()
  @tuple_b 12..101 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  #############
  # Semigroup #
  #############

  bench "append/2", do: append(@tuple_a, @tuple_b)
  bench "repeat/2", do: repeat(@tuple_a, times: 100)

  # --------- #
  # Operators #
  # --------- #

  bench "<>/2", do: @tuple_a <> @tuple_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_tuple_a 0..100_000  |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()
  @big_tuple_b 1..100_001  |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  bench "$$$ append/2", do: append(@big_tuple_a, @big_tuple_b)
  bench "$$$ <>/2",     do: @big_tuple_a <> @big_tuple_b

end
