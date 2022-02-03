defmodule Witchcraft.Ord.MapBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Ord

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list_a 11..100 |> Enum.to_list() |> Enum.shuffle()
  @list_b 99..999 |> Enum.to_list() |> Enum.shuffle()

  @map_a @list_a |> Enum.zip(@list_b) |> Enum.into(%{})
  @map_b @list_b |> Enum.zip(@list_a) |> Enum.into(%{})

  ##########
  # Kernel #
  ##########

  bench("Kernel.>/2", do: Kernel.>(@map_a, @map_b))
  bench("Kernel.</2", do: Kernel.<(@map_a, @map_b))

  bench("Kernel.>=/2", do: Kernel.>=(@map_a, @map_b))
  bench("Kernel.<=/2", do: Kernel.<=(@map_a, @map_b))

  #######
  # Ord #
  #######

  bench("compare/2", do: compare(@map_a, @map_b))

  bench("equal?/2", do: equal?(@map_a, @map_b))
  bench("greater?/2", do: greater?(@map_a, @map_b))
  bench("lesser/2", do: lesser?(@map_a, @map_b))

  # --------- #
  # Operators #
  # --------- #

  bench(">/2", do: @map_a > @map_b)
  bench("</2", do: @map_a < @map_b)

  bench(">=/2", do: @map_a >= @map_b)
  bench("<=/2", do: @map_a <= @map_b)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..100_000 |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999_999 |> Enum.to_list() |> Enum.shuffle()

  @big_map_a @big_list_a |> Enum.zip(@list_b) |> Enum.into(%{})
  @big_map_b @big_list_b |> Enum.zip(@list_a) |> Enum.into(%{})

  bench("$$$ Kernel.>/2", do: Kernel.>(@big_map_a, @big_map_b))
  bench("$$$ Kernel.</2", do: Kernel.<(@big_map_a, @big_map_b))

  bench("$$$ </2", do: @big_map_a < @big_map_b)
  bench("$$$ >/2", do: @big_map_a > @big_map_b)
end
