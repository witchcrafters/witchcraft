defmodule Witchcraft.Semigroup.ListBench do
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

  ##########
  # Kernel #
  ##########

  bench "Kernel.++/2", do: @list_a ++ @list_b

  #############
  # Semigroup #
  #############

  bench "append/2", do: append(@list_a, @list_b)
  bench "repeat/2", do: repeat(@list_a, times: 100)

  # --------- #
  # Operators #
  # --------- #

  bench "<>/2", do: @list_a <> @list_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..100_000  |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999_999 |> Enum.to_list() |> Enum.shuffle()

  bench "$$$ Kernel.++/2", do: @big_list_a ++ @big_list_b
  bench "$$$ append/2",    do: append(@big_list_a, @big_list_b)
  bench "$$$ <>/2",        do: @big_list_a <> @big_list_b

end
