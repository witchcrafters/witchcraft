defmodule Witchcraft.Monoid.BitStringBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @string "hello"

  ##########
  # Monoid #
  ##########

  bench "empty/1",  do: empty(@string)
  bench "empty?/1", do: empty?(@string)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..100_000  |> Enum.to_list() |> inspect()

  bench "$$$ empty/1",  do: empty(@string)
  bench "$$$ empty?/1", do: empty?(@string)

end
