defmodule Witchcraft.Comonad.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Comonad

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple 11..100 |> Enum.to_list() |> Enum.map(&{&1, &1}) |> Enum.shuffle() |> List.to_tuple()

  ###########
  # Comonad #
  ###########

  bench("extract/1", do: extract(@tuple))

  # ---------- #
  # Large Data #
  # ---------- #

  @big_tuple 0..100_000
             |> Enum.to_list()
             |> Enum.map(&{&1, &1})
             |> Enum.shuffle()
             |> List.to_tuple()

  bench("$$$ extract/1", do: extract(@big_tuple))
end
