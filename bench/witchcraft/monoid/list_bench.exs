defmodule Witchcraft.Monoid.ListBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list 0..10 |> Enum.to_list()

  ##########
  # Monoid #
  ##########

  bench "empty/1",  do: empty(@list)
  bench "empty?/1", do: empty?(@list)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list 0..100_000 |> Enum.to_list()

  bench "$$$ empty/1",  do: empty(@big_list)
  bench "$$$ empty?/1", do: empty?(@big_list)

end
