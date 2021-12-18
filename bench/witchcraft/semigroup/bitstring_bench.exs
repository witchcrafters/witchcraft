defmodule Witchcraft.Semigroup.BitStringBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Semigroup

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @string_a 11..100 |> Enum.to_list() |> Enum.shuffle() |> inspect()
  @string_b 99..999 |> Enum.to_list() |> Enum.shuffle() |> inspect()

  ##########
  # Kernel #
  ##########

  bench "Kernel.<>/2", do: @string_a <> @string_b

  #############
  # Semigroup #
  #############

  bench "append/2", do: append(@string_a, @string_b)
  bench "repeat/2", do: repeat(@string_a, times: 100)

  # --------- #
  # Operators #
  # --------- #

  bench "<>/2", do: @string_a <> @string_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_string_a 0..100_000  |> Enum.to_list() |> Enum.shuffle() |> inspect()
  @big_string_b 99..999_999 |> Enum.to_list() |> Enum.shuffle() |> inspect()

  bench "$$$ Kernel.<>/2", do: @big_string_a <> @big_string_b
  bench "$$$ append/2",   do: append(@big_string_a, @big_string_b)
  bench "$$$ <>/2",       do: @big_string_a <> @big_string_b

end
