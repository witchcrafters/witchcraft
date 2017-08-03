defmodule Witchcraft.Functor.MapBench do
  use Benchfella
  use Witchcraft.Functor

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list Enum.to_list(0..10_000)
  @map  @list |> Enum.zip(@list) |> Enum.into(%{})

  # -------------- #
  # Test Functions #
  # -------------- #

  defp square(x), do: x * x

  ########
  # Enum #
  ########

  bench "Enum.map/2", do: @map |> Enum.map(fn {x, y} -> {x, y * y} end) |> Enum.into(%{})

  ##############
  # Witchcraft #
  ##############

  # ====== #
  # Static #
  # ====== #

  bench "map/2",     do: map(@map, &square/1)
  bench "across/2",  do: across(&square/1, @map)
  bench "replace/2", do: replace(@map, 42)

  # ----- #
  # Async #
  # ----- #

  bench "async_map/2",    do: async_map(@map, &square/1)
  bench "async_across/2", do: async_across(&square/1, @map)

  # ======= #
  # Curried #
  # ======= #

  bench "lift/2", do: lift(@map, &square/1)
  bench "over/2", do: over(&square/1, @map)

  # ------------- #
  # Async Curried #
  # ------------- #

  bench "async_lift/2", do: async_lift(@map, &square/1)
  bench "async_over/2", do: async_over(&square/1, @map)

  # --------- #
  # Operators #
  # --------- #

  bench "~>/2", do: @map ~> (&square/1)
  bench "<~/2", do: (&square/1) <~ @map
end
