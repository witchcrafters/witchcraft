defmodule Witchcraft.Traversable.ListBench do
  @moduledoc false

  require Integer

  use Benchfella
  use Witchcraft.Traversable

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list Enum.to_list(0..10)
  @nested_list replace(@list, {1, 2, 3, 4, 5})

  ###############
  # Traversable #
  ###############

  bench "traverse/2", do: @list |> traverse(fn x -> {x, x + 1} end)
  bench "through/2",  do: fn x -> {x, x + 1} end |> through(@list)

  bench "sequence/1", do: sequence(@nested_list)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list Enum.to_list(0..10_000)
  @med_list Enum.to_list(0..250)

  @big_nested_list replace(@med_list, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9})

  bench "$$$ traverse/2", do: @big_list |> traverse(fn x -> {x, x + 1} end)
  bench "$$$ through/2",  do: fn x -> {x, x + 1} end |> through(@big_list)

  bench "$$$ sequence/1", do: sequence(@big_nested_list)

end
