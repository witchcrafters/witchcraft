defmodule Witchcraft.Setoid.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Setoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple_a 11..100 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()
  @tuple_b 99..999 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  ##########
  # Kernel #
  ##########

  bench "Kernel.==/2", do: Kernel.==(@tuple_a, @tuple_b)
  bench "Kernel.!=/2", do: Kernel.!=(@tuple_a, @tuple_b)

  ##########
  # Setoid #
  ##########

  bench "equivalent?/2",    do: equivalent?(@tuple_a, @tuple_b)
  bench "nonequivalent?/2", do: nonequivalent?(@tuple_a, @tuple_b)

  # --------- #
  # Operators #
  # --------- #

  bench "==/2", do: @tuple_a == @tuple_b
  bench "!=/2", do: @tuple_a != @tuple_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_tuple_a 0..100_000  |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()
  @big_tuple_b 99..999_999 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  bench "$$$ Kernel.==/2", do: Kernel.==(@big_tuple_a, @big_tuple_b)
  bench "$$$ Kernel.!=/2", do: Kernel.!=(@big_tuple_a, @big_tuple_b)

  bench "$$$ ==/2", do: @big_tuple_a == @big_tuple_b
  bench "$$$ !=/2", do: @big_tuple_a != @big_tuple_b
end
