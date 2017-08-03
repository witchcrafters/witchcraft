defmodule Witchcraft.Apply.ListBench do
  use Benchfella
  use Witchcraft.Apply

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list_a 1..10 |> Enum.to_list() |> Enum.shuffle()
  @list_b 9..99 |> Enum.to_list() |> Enum.shuffle()

  #########
  # Apply #
  #########

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..1_000 |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999 |> Enum.to_list() |> Enum.shuffle()

end



# <<~/2
# ap/2
# async_ap/2
# async_convey/2
# async_lift/3
# async_lift/4
# async_lift/5
# async_over/3
# async_over/4
# async_over/5
# convey/2
# following/2
# hose/2
# lift/3
# lift/4
# lift/5
# over/3
# over/4
# over/5
# provide/2
# supply/2
# then/2
# ~>>/2
