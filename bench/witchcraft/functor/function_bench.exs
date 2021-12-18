defmodule Witchcraft.Functor.FunctionBench do
  @moduledoc false

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

  ##########
  # Simple #
  ##########

  bench "apply Functor",         do: map(&fun/1, &twice/1).(1)
  bench "inline apply composed", do: fn x -> x |> fun() |> twice() end.(1)

  bench "inline application", do: 1 |> fun() |> twice()
  bench "inline composition", do: fn x -> x |> fun() |> twice()  end

  bench "naive compose function" do
    fn(f, g) ->
      fn x -> x |> f.() |> g.() end
    end.(&fun/1, &twice/1)
  end

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


  ########################
  # Expensive Operations #
  ########################

  defp expensive(x) do
    Process.sleep(50)
    x
  end

  # ---------- #
  # Sequential #
  # ---------- #

  bench "$$$ map/2",  do: map(&fun/1,  &expensive/1)
  bench "$$$ lift/2", do: lift(&fun/1, &expensive/1)

  # ----- #
  # Async #
  # ----- #

  bench "$$$ async_map/2",  do: async_map(&fun/1,  &expensive/1)
  bench "$$$ async_lift/2", do: async_lift(&fun/1, &expensive/1)
end
