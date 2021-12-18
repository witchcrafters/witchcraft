defmodule Witchcraft.Functor.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Functor

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple 0..10_000 |> Enum.to_list() |> List.to_tuple()

  # -------------- #
  # Test Functions #
  # -------------- #

  defp square(x), do: x * x

  ########
  # Enum #
  ########

  bench "Enum.map/2", do: @tuple |> Tuple.to_list() |> Enum.map(&square/1) |> List.to_tuple()

  ##############
  # Witchcraft #
  ##############

  # ====== #
  # Static #
  # ====== #

  bench "map/2",     do: map(@tuple, &square/1)
  bench "across/2",  do: across(&square/1, @tuple)
  bench "replace/2", do: replace(@tuple, 42)

  # ----- #
  # Async #
  # ----- #

  bench "async_map/2",    do: async_map(@tuple, &square/1)
  bench "async_across/2", do: async_across(&square/1, @tuple)

  # ======= #
  # Curried #
  # ======= #

  bench "lift/2", do: lift(@tuple, &square/1)
  bench "over/2", do: over(&square/1, @tuple)

  # ------------- #
  # Async Curried #
  # ------------- #

  bench "async_lift/2", do: async_lift(@tuple, &square/1)
  bench "async_over/2", do: async_over(&square/1, @tuple)

  # --------- #
  # Operators #
  # --------- #

  bench "~>/2", do: @tuple ~> (&square/1)
  bench "<~/2", do: (&square/1) <~ @tuple


  ########################
  # Expensive Operations #
  ########################

  @small_tuple 0..100 |> Enum.to_list() |> List.to_tuple()

  defp expensive(x) do
    Process.sleep(50)
    x
  end

  # ---------- #
  # Sequential #
  # ---------- #

  bench "$$$ map/2",  do: map(@small_tuple,  &expensive/1)
  bench "$$$ lift/2", do: lift(@small_tuple, &expensive/1)

  # ----- #
  # Async #
  # ----- #

  bench "$$$ async_map/2",  do: async_map(@small_tuple,  &expensive/1)
  bench "$$$ async_lift/2", do: async_lift(@small_tuple, &expensive/1)
end
