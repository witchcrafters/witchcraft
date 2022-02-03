defmodule Witchcraft.Traversable.TupleBench do
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

  @tuple {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
  @nested_tuple replace(@tuple, [1, 2, 3, 4, 5])

  ###############
  # Traversable #
  ###############

  bench("traverse/2", do: @tuple |> traverse(fn x -> [x, x + 1] end))
  bench("through/2", do: fn x -> [x, x + 1] end |> through(@tuple))

  bench("sequence/1", do: sequence(@nested_tuple))

  # ---------- #
  # Large Data #
  # ---------- #

  @big_tuple 0..10_000 |> Enum.to_list() |> List.to_tuple()
  @med_tuple 0..250 |> Enum.to_list() |> List.to_tuple()

  @big_nested_tuple replace(@med_tuple, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

  bench("$$$ traverse/2", do: @big_tuple |> traverse(fn x -> [x, x + 1] end))
  bench("$$$ through/2", do: fn x -> [x, x + 1] end |> through(@big_tuple))

  bench("$$$ sequence/1", do: sequence(@big_nested_tuple))
end
