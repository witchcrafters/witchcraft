defmodule Witchcraft.Ord.BitStringBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Ord

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

  bench "Kernel.>/2",  do: Kernel.>(@string_a, @string_b)
  bench "Kernel.</2",  do: Kernel.<(@string_a, @string_b)

  bench "Kernel.>=/2", do: Kernel.>=(@string_a, @string_b)
  bench "Kernel.<=/2", do: Kernel.<=(@string_a, @string_b)

  #######
  # Ord #
  #######

  bench "compare/2", do: compare(@string_a, @string_b)

  bench "equal?/2",   do: equal?(@string_a, @string_b)
  bench "greater?/2", do: greater?(@string_a, @string_b)
  bench "lesser/2",   do: lesser?(@string_a, @string_b)

  # --------- #
  # Operators #
  # --------- #

  bench ">/2", do: @string_a > @string_b
  bench "</2", do: @string_a < @string_b

  bench ">=/2", do: @string_a >= @string_b
  bench "<=/2", do: @string_a <= @string_b

  # ---------- #
  # Large Data #
  # ---------- #

  @big_string_a 0..100_000  |> Enum.to_list() |> Enum.shuffle() |> inspect()
  @big_string_b 99..999_999 |> Enum.to_list() |> Enum.shuffle() |> inspect()

  bench "$$$ Kernel.>/2", do: Kernel.>(@big_string_a, @big_string_b)
  bench "$$$ Kernel.</2", do: Kernel.<(@big_string_a, @big_string_b)

  bench "$$$ </2", do: @big_string_a < @big_string_b
  bench "$$$ >/2", do: @big_string_a > @big_string_b
end
