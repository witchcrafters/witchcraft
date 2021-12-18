defmodule Witchcraft.Extend.ListBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Extend

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list 0..10 |> Enum.to_list()

  ##########
  # Extend #
  ##########

  bench "nest/1", do: nest(@list)

  bench "extend/2",         do: extend(@list, fn [x | _] -> x + 1 end)
  bench "curried_extend/2", do: curried_extend(@list, fn [x | _] -> x + 1 end)

  bench "peel/2",         do: peel(fn [x | _] -> x + 1 end, @list)
  bench "curried_peel/2", do: curried_peel(fn [x | _] -> x + 1 end, @list)

  bench "compose_colink/2",      do: compose_colink(fn [x | _] -> x + 1 end, fn [y | _] -> y * 10 end)
  bench "pipe_compose_colink/2", do: pipe_compose_colink(fn [y | _] -> y * 10 end, fn [x | _] -> x + 1 end)

  bench "apply compose_colink/2" do
    both = compose_colink(fn [x | _] -> x + 1 end, fn [y | _] -> y * 10 end)
    extend(@list, both)
  end

  bench "apply pipe_compose_colink/2" do
    both = pipe_compose_colink(fn [x | _] -> x + 1 end, fn [y | _] -> y * 10 end)
    extend(@list, both)
  end

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list 0..100_000 |> Enum.to_list()

  bench "$$$ nest/1", do: nest(@big_list)

  bench "$$$ extend/2",         do: extend(@big_list, fn [x | _] -> x + 1 end)
  bench "$$$ curried_extend/2", do: curried_extend(@big_list, fn [x | _] -> x + 1 end)

end
