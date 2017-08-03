defmodule Witchcraft.Functor.FunctionBench do
  use Benchfella
  use Witchcraft.Functor

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  def fun(x), do: "#{inspect x}-#{inspect x}"

  # -------------- #
  # Test Functions #
  # -------------- #

  defp twice(f), do: fn x -> x |> f.() |> f.() end

  ########
  # Enum #
  ########

  bench "fn  manual compose", do: fn x -> twice(&fun/1).(x) end

  ##############
  # Witchcraft #
  ##############

  # ====== #
  # Static #
  # ====== #

  bench "map/2",     do: map(&fun/1, &twice/1)
  bench "across/2",  do: across(&twice/1, &fun/1)
  bench "replace/2", do: replace(&fun/1, 42)

  # ----- #
  # Async #
  # ----- #

  bench "async_map/2",    do: async_map(&fun/1, &twice/1)
  bench "async_across/2", do: async_across(&twice/1, &fun/1)

  # ======= #
  # Curried #
  # ======= #

  bench "lift/2", do: lift(&fun/1, &twice/1)
  bench "over/2", do: over(&twice/1, &fun/1)

  # ------------- #
  # Async Curried #
  # ------------- #

  bench "async_lift/2", do: async_lift(&fun/1, &twice/1)
  bench "async_over/2", do: async_over(&twice/1, &fun/1)

  # --------- #
  # Operators #
  # --------- #

  bench "~>/2", do: (&fun/1) ~> (&twice/1)
  bench "<~/2", do: (&twice/1) <~ (&fun/1)
end
