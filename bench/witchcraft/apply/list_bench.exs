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

  @fun_list_a [&(&1 + 1), &(&1 * 10), &(&1 * 1), &(&1 - 4), &inspect/1]
  @fun_list_b @list_a |> replace(fn x -> "#{inspect x}-#{inspect x}" end)

  #########
  # Apply #
  #########

  bench "data convey/2", do: @list_a |> convey(@fun_list_a)
  bench "funs convey/2", do: @list_b |> convey(@fun_list_b)

  bench "data ap/2", do: @fun_list_a |> ap(@list_a)
  bench "funs ap/2", do: @fun_list_b |> ap(@list_b)

  bench "data <<~/2", do: @fun_list_a <<~ @list_a
  bench "funs <<~/2", do: @fun_list_b <<~ @list_b

  bench "data ~>>/2", do: @list_a ~>> @fun_list_a
  bench "funs ~>>/2", do: @list_b ~>> @fun_list_b

  bench "provide/2"
  bench "supply/2"

  bench "lift/3"
  bench "lift/4"
  bench "lift/5"

  bench "over/3"
  bench "over/4"
  bench "over/5"

  # ----- #
  # Async #
  # ----- #

  bench "async_ap/2"
  bench "async_convey/2"

  bench "async_lift/3"
  bench "async_lift/4"
  bench "async_lift/5"

  bench "async_over/3"
  bench "async_over/4"
  bench "async_over/5"

  bench "following/2"
  bench "then/2"

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..1_000 |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999 |> Enum.to_list() |> Enum.shuffle()

  # don't forget to change names so taht they actually run

  bench "data convey/2", do: @list_a |> convey(@fun_list_a)
  bench "funs convey/2", do: @list_b |> convey(@fun_list_b)

  bench "data ap/2", do: @fun_list_a |> ap(@list_a)
  bench "funs ap/2", do: @fun_list_b |> ap(@list_b)

  bench "data <<~/2", do: @fun_list_a <<~ @list_a
  bench "funs <<~/2", do: @fun_list_b <<~ @list_b

  bench "data ~>>/2", do: @list_a ~>> @fun_list_a
  bench "funs ~>>/2", do: @list_b ~>> @fun_list_b

  bench "provide/2"
  bench "supply/2"

  bench "lift/3"
  bench "lift/4"
  bench "lift/5"

  bench "over/3"
  bench "over/4"
  bench "over/5"

  # -------------------------- #
  # Large Function Collections #
  # -------------------------- #

  bench "data convey/2", do: @list_a |> convey(@fun_list_a)
  bench "funs convey/2", do: @list_b |> convey(@fun_list_b)

  bench "data ap/2", do: @fun_list_a |> ap(@list_a)
  bench "funs ap/2", do: @fun_list_b |> ap(@list_b)

  bench "data <<~/2", do: @fun_list_a <<~ @list_a
  bench "funs <<~/2", do: @fun_list_b <<~ @list_b

  bench "data ~>>/2", do: @list_a ~>> @fun_list_a
  bench "funs ~>>/2", do: @list_b ~>> @fun_list_b

  bench "provide/2"
  bench "supply/2"

  bench "lift/3"
  bench "lift/4"
  bench "lift/5"

  bench "over/3"
  bench "over/4"
  bench "over/5"

end
