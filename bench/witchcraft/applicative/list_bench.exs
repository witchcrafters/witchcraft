defmodule Witchcraft.Applicative.ListBench do
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
  @list 99..999 |> Enum.to_list() |> Enum.shuffle()

  # -------------- #
  # Test Functions #
  # -------------- #

  defp to_list(x), do: of(@list).(x)

  ###############
  # Applicative #
  ###############

  bench "of/1", do: to_list(@to_wrap)
  bench "of/2", do: of(@list, @to_wrap)

end
