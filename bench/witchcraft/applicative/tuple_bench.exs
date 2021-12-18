defmodule Witchcraft.Applicative.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Applicative

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @to_wrap 11..100 |> Enum.to_list() |> Enum.shuffle()
  @tuple 99..999 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  # -------------- #
  # Test Functions #
  # -------------- #

  defp to_tuple(x), do: of(@tuple).(x)

  ###############
  # Applicative #
  ###############

  bench("of/1", do: to_tuple(@to_wrap))
  bench("of/2", do: of(@tuple, @to_wrap))
end
