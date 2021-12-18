defmodule Witchcraft.Bifunctor.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Bifunctor

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple 11..100 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  # -------------- #
  # Test Functions #
  # -------------- #

  defp add_one(x), do: x + 1
  defp times_ten(y), do: y * 10

  ###########
  # Comonad #
  ###########

  bench("bimap/3", do: bimap(@tuple, &add_one/1, &times_ten/1))
  bench("map_first/2", do: map_first(@tuple, &add_one/1))
  bench("map_second/2", do: map_second(@tuple, &add_one/1))

  bench("bilift/3", do: bilift(@tuple, &add_one/1, &times_ten/1))
  bench("lift_first/2", do: lift_first(@tuple, &add_one/1))
  bench("lift_second/2", do: lift_second(@tuple, &add_one/1))

  # ---------- #
  # Large Data #
  # ---------- #

  @big_tuple 0..100_000 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  bench("$$$ bimap/3", do: bimap(@big_tuple, &add_one/1, &times_ten/1))
  bench("$$$ map_first/2", do: map_first(@big_tuple, &add_one/1))
  bench("$$$ map_second/2", do: map_second(@big_tuple, &add_one/1))

  bench("$$$ bilift/3", do: bilift(@big_tuple, &add_one/1, &times_ten/1))
  bench("$$$ lift_first/2", do: lift_first(@big_tuple, &add_one/1))
  bench("$$$ lift_second/2", do: lift_second(@big_tuple, &add_one/1))
end
