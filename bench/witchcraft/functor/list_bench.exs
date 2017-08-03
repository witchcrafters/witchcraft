defmodule Witchcraft.Functor.ListBench do
  use Benchfella
  use Witchcraft.Functor

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list Enum.to_list(0..10_000)

  # -------------- #
  # Test Functions #
  # -------------- #

  defp square(x), do: x * x

  ########
  # Enum #
  ########

  bench "Enum.map/2", do: Enum.map(@list, &square/1)

  ##############
  # Witchcraft #
  ##############

  # ====== #
  # Static #
  # ====== #

  bench "map/2",     do: map(@list, &square/1)
  bench "across/2",  do: across(&square/1, @list)
  bench "replace/2", do: replace(@list, 42)

  # ----- #
  # Async #
  # ----- #

  bench "async_map/2",    do: async_map(@list, &square/1)
  bench "async_across/2", do: async_across(&square/1, @list)

  # ======= #
  # Curried #
  # ======= #

  bench "lift/2", do: lift(@list, &square/1)
  bench "over/2", do: over(&square/1, @list)

  # ------------- #
  # Async Curried #
  # ------------- #

  bench "async_lift/2", do: async_lift(@list, &square/1)
  bench "async_over/2", do: async_over(&square/1, @list)

  # --------- #
  # Operators #
  # --------- #

  bench "~>/2", do: @list ~> (&square/1)
  bench "<~/2", do: (&square/1) <~ @list
end
