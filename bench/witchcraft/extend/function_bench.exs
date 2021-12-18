defmodule Witchcraft.Extend.FunctionBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Extend
  use Quark

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  defp fun(x),    do: x + 1
  defp twice(f),  do: f <|> f
  defp thrice(f), do: f <|> f <|> f

  ##########
  # Extend #
  ##########

  bench "nest/1", do: nest(&fun/1)

  bench "extend/2",         do: extend(&fun/1, &twice/1)
  bench "curried_extend/2", do: curried_extend(&fun/1, &twice/1)

  bench "peel/2",         do: peel(&twice/1, &fun/1)
  bench "curried_peel/2", do: curried_peel(&twice/1, &fun/1)

  bench "compose_colink/2",      do: compose_colink(&twice/1, &thrice/1)
  bench "pipe_compose_colink/2", do: pipe_compose_colink(&thrice/1, &twice/1)

  bench "apply compose_colink/2" do
    both = compose_colink(&twice/1, &thrice/1)
    extend(&fun/1, both)
  end

  bench "apply pipe_compose_colink/2" do
    both = pipe_compose_colink(&thrice/1, &twice/1)
    extend(&fun/1, both)
  end

end
