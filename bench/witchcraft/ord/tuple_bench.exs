defmodule Witchcraft.Ord.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Ord

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

  bench "Kernel.>/2",  do: Kernel.>(@tuple_a, @tuple_b)
  bench "Kernel.</2",  do: Kernel.<(@tuple_a, @tuple_b)

  bench "Kernel.>=/2", do: Kernel.>=(@tuple_a, @tuple_b)
  bench "Kernel.<=/2", do: Kernel.<=(@tuple_a, @tuple_b)

  #######
  # Ord #
  #######

  bench "compare/2", do: compare(@tuple_a, @tuple_b)

  bench "equal?/2",   do: equal?(@tuple_a, @tuple_b)
  bench "greater?/2", do: greater?(@tuple_a, @tuple_b)
  bench "lesser/2",   do: lesser?(@tuple_a, @tuple_b)

  # --------- #
  # Operators #
  # --------- #

  bench ">/2", do: @tuple_a > @tuple_b
  bench "</2", do: @tuple_a < @tuple_b

  bench ">=/2", do: @tuple_a >= @tuple_b
  bench "<=/2", do: @tuple_a <= @tuple_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_tuple_a 0..100_000  |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()
  @big_tuple_b 99..999_999 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  bench "$$$ Kernel.>/2", do: Kernel.>(@big_tuple_a, @big_tuple_b)
  bench "$$$ Kernel.</2", do: Kernel.<(@big_tuple_a, @big_tuple_b)

  bench "$$$ </2", do: @big_tuple_a < @big_tuple_b
  bench "$$$ >/2", do: @big_tuple_a > @big_tuple_b
end
