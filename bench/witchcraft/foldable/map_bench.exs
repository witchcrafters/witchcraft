defmodule Witchcraft.Foldable.MapBench do
  require Integer

  use Benchfella
  use Witchcraft.Foldable

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list Enum.to_list(0..10)
  @map @list |> Enum.zip(@list) |> Enum.into(%{})

  ############
  # Foldable #
  ############

  bench "Enum.all?/1", do: Enum.all?(%{a: true, b: false, c: true, d: true, e: false})

  bench "all?/1", do: all?(%{a: true, b: false, c: true, d: true, e: false})
  bench "all?/2", do: all?(@map, fn x -> x > 5 end)

  bench "Enum.any?/1", do: Enum.any?%{a: true, b: false, c: true, d: true, e: false}()

  bench "any?/1", do: any?(%{a: true, b: false, c: true, d: true, e: false})
  bench "any?/2", do: any?(@map, fn x -> x > 5 end)

  bench "flatten/1",  do: flatten([@map, @map, @map])

  bench "Enum.flat_map/2", do: Enum.flat_map(@map, fn x -> [x, x + 1] end)
  bench "flat_map/2", do: flat_map(@map, fn x -> [x, x + 1] end)

  bench "Enum.count/1", do: Enum.count(@map)

  bench "count/1",  do: count(@map)
  bench "length/1", do: length(@map)

  bench "empty?/1", do: empty?(@map)
  bench "null?/1",  do: null?(@map)

  bench "Enum.member?/2", do: Enum.member?(@map, 99)
  bench "member?/2", do: member?(@map, 99)

  bench "Enum.max/1", do: Enum.max(@map)
  bench "max/1", do: max(@map)

  bench "Enum.max_by/2", do: Enum.max_by(@map, fn(x) -> Integer.mod(x, 3) end) # Cheating a bit
  bench "max/2", do: max(@map, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  bench "Enum.min/1", do: Enum.min(@map)
  bench "min/1", do: min(@map)

  bench "Enum.min_by/2", do: Enum.min_by(@map, fn(x) -> Integer.mod(x, 3) end) # Cheating a bit
  bench "min/2", do: min(@map, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  bench "Enum.sum/1", do: Enum.sum(@map)
  bench "sum/1", do: sum(@map)

  bench "&Enum.reduce(&1, &*/2)", do: Enum.reduce(@map, &*/2)
  bench "product/1", do: product(@map)

  bench "Enum.random/1" do
    Enum.random(@map)
    true # get Benchfella to match on multiple runs
  end

  bench "random/1" do
    random(@map)
    true # get Benchfella to match on multiple runs
  end

  bench "fold/1",     do: fold(@map)
  bench "fold_map/2", do: fold_map(@map, fn x -> [x, x + 1] end)

  bench "Enum.map_reduce/3 + []" do
    @map
    |> Enum.map_reduce([], fn(x, acc) -> {[x + 1 | acc], nil} end)
    |> elem(0)
  end

  bench "left_fold/2", do: left_fold(@map, fn(acc, x) -> [x + 1 | acc] end)
  bench "left_fold/3", do: left_fold(@map, @map, fn(acc, x) -> [x + 1 | acc] end)

  bench "List.foldl/3 + []", do: List.foldl(@map, [], fn(x, acc) -> [x + 1 | acc]end)
  bench "List.foldl/3", do: List.foldl(@map, @map, fn(x, acc) -> [x + 1 | acc] end)

  bench "right_fold/3 + []", do: right_fold(@map, [], fn(x, acc) -> [x + 1 | acc] end)
  bench "right_fold/3", do: right_fold(@map, @map, fn(x, acc) -> [x + 1 | acc] end)

  bench "Enum.reduce/2", do: Enum.reduce(@map, fn(x, acc) -> [x + 1 | acc] end)
  bench "Enum.reduce/3", do: Enum.reduce(@map, @map, fn(x, acc) -> [x + 1 | acc] end)

  bench "List.foldr/3 + []", do: List.foldr(@map, [], fn(x, acc) -> [x + 1 | acc]end)
  bench "List.foldr/3", do: List.foldr(@map, @map, fn(x, acc) -> [x + 1 | acc] end)

  bench "size/1", do: size(@map)

  bench "then_sequence/1", do: then_sequence([@map, @map, @map])

  bench "Enum.to_list/1", do: Enum.to_list(@map)
  bench "to_list/1",      do: to_list(@map)

  # ---------- #
  # Large Data #
  # ---------- #

  # @big_map Enum.to_list(0..10_000)
  # @med_map Enum.to_list(0..250)
  # @bools  Enum.map(@big_map, fn _ -> Enum.random([true, false]) end)
  # @nested fn -> [1, 2, 3] end |> Stream.repeatedly() |> Enum.take(10)

  # bench "$$$ Enum.all?/1", do: Enum.all?(@bools)

  # bench "$$$ all?/1", do: all?(@bools)
  # bench "$$$ all?/2", do: all?(@big_map, fn x -> x > 5 end)

  # bench "$$$ Enum.any?/1", do: Enum.any?(@bools)

  # bench "$$$ any?/1", do: any?([true, true, true, true, true, false])
  # bench "$$$ any?/2", do: any?(@big_map, fn x -> x > 5 end)

  # bench "$$$ List.flatten/1",  do: List.flatten([@big_map, @big_map, @big_map, @big_map, @big_map])
  # bench "$$$ flatten/1",  do: flatten([@big_map, @big_map, @big_map, @big_map, @big_map])

  # bench "$$$ Enum.flat_map/2", do: Enum.flat_map(@big_map, fn x -> [x, x + 1] end)
  # bench "$$$ flat_map/2", do: flat_map(@big_map, fn x -> [x, x + 1] end)

  # bench "$$$ Enum.count/1", do: Enum.count(@big_map)

  # bench "$$$ Enum.count/1", do: Enum.count(@big_map)

  # bench "$$$ count/1",  do: count(@big_map)
  # bench "$$$ length/1", do: length(@big_map)

  # bench "$$$ empty?/1",  do: empty?(@big_map)
  # bench "$$$ null?/1",   do: null?(@big_map)

  # bench "$$$ Enum.member?/2", do: Enum.member?(@big_map, 99)
  # bench "$$$ member?/2", do: member?(@big_map, 99)

  # bench "$$$ Enum.max/1", do: Enum.max(@big_map)
  # bench "$$$ max/1", do: max(@big_map)

  # bench "$$$ Enum.max_by/2", do: Enum.max_by(@big_map, fn(x) -> Integer.mod(x, 3) end) # Cheating a bit
  # bench "$$$ max/2", do: max(@big_map, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  # bench "$$$ Enum.min/1", do: Enum.min(@big_map)
  # bench "$$$ min/1", do: min(@big_map)

  # bench "$$$ Enum.min_by/2", do: Enum.min_by(@big_map, fn(x) -> Integer.mod(x, 3) end) # Cheating a bit
  # bench "$$$ min/2", do: min(@big_map, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  # bench "$$$ Enum.sum/1", do: Enum.sum(@big_map)
  # bench "$$$ sum/1", do: sum(@big_map)

  # bench "$$$ &Enum.reduce(&1, &*/2)", do: Enum.reduce(@big_map, &*/2)
  # bench "$$$ product/1", do: product(@big_map)

  # bench "$$$ Enum.random/1" do
  #   Enum.random(@big_map)
  #   true # get Benchfella to match on multiple runs
  # end

  # bench "$$$ random/1" do
  #   random(@big_map)
  #   true # get Benchfella to match on multiple runs
  # end

  # bench "$$$ fold/1",     do: fold(@big_map)
  # bench "$$$ fold_map/2", do: fold_map(@big_map, fn x -> [x, x + 1] end)

  # bench "$$$ Enum.map_reduce/3 + []" do
  #   @big_map
  #   |> Enum.map_reduce([], fn(x, acc) -> {[x + 1 | acc], nil} end)
  #   |> elem(0)
  # end

  # bench "$$$ left_fold/2", do: left_fold(@big_map, fn(acc, x) -> [x + 1 | acc] end)
  # bench "$$$ left_fold/3", do: left_fold(@big_map, @big_map, fn(acc, x) -> [x + 1 | acc] end)

  # bench "$$$ List.foldl/3 + []", do: List.foldl(@big_map, [], fn(x, acc) -> [x + 1 | acc]end)
  # bench "$$$ List.foldl/3", do: List.foldl(@big_map, @big_map, fn(x, acc) -> [x + 1 | acc] end)

  # bench "$$$ right_fold/3 + []", do: right_fold(@big_map, [], fn(x, acc) -> [x + 1 | acc] end)
  # bench "$$$ right_fold/3", do: right_fold(@big_map, @big_map, fn(x, acc) -> [x + 1 | acc] end)

  # bench "$$$ Enum.reduce/2", do: Enum.reduce(@big_map, fn(x, acc) -> [x + 1 | acc] end)
  # bench "$$$ Enum.reduce/3", do: Enum.reduce(@big_map, @big_map, fn(x, acc) -> [x + 1 | acc] end)

  # bench "$$$ List.foldr/3 + []", do: List.foldr(@big_map, [], fn(x, acc) -> [x + 1 | acc]end)
  # bench "$$$ List.foldr/3", do: List.foldr(@big_map, @big_map, fn(x, acc) -> [x + 1 | acc] end)

  # bench "$$$ size/1", do: size(@big_map)

  # bench "$$$ med then_sequence/1", do: then_sequence([@med_map, @med_map, @med_map])
  # bench "$$$ sml then_sequence/1", do: then_sequence(@nested)

  # bench "$$$ Enum.to_list/1", do: Enum.to_list(@big_map)
  # bench "$$$ to_list/1",      do: to_list(@big_map)

end
