defmodule Witchcraft.Setoid.ListBench do
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

  ##########
  # Kernel #
  ##########

  bench "Kernel.==/2", do: Kernel.==(@list_a, @list_b)
  bench "Kernel.!=/2", do: Kernel.!=(@list_a, @list_b)

  ##########
  # Setoid #
  ##########

  bench "equivalent?/2",    do: equivalent?(@list_a, @list_b)
  bench "nonequivalent?/2", do: nonequivalent?(@list_a, @list_b)

  # --------- #
  # Operators #
  # --------- #

  bench "==/2", do: @list_a == @list_b
  bench "!=/2", do: @list_a != @list_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..100_000  |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999_999 |> Enum.to_list() |> Enum.shuffle()

  bench "$$$ Kernel.==/2", do: Kernel.==(@big_list_a, @big_list_b)
  bench "$$$ Kernel.!=/2", do: Kernel.!=(@big_list_a, @big_list_b)

  bench "$$$ ==/2", do: @big_list_a == @big_list_b
  bench "$$$ !=/2", do: @big_list_a != @big_list_b
end
