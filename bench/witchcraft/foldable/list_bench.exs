defmodule Witchcraft.Foldable.ListBench do
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

  ############
  # Foldable #
  ############

  bench "Enum.all?/1", do: Enum.all?([true, true, true, true, false])

  bench "all?/1", do: all?([true, true, true, true, true, false])
  bench "all?/2", do: all?(@list, fn x -> x > 5 end)

  bench "Enum.any?/1", do: Enum.any?([true, true, true, true, false])

  bench "any?/1", do: any?([true, true, true, true, true, false])
  bench "any?/2", do: any?(@list, fn x -> x > 5 end)

  bench "List.flatten/1",  do: List.flatten([@list, @list, @list])
  bench "flatten/1",  do: flatten([@list, @list, @list])

  bench "Enum.flat_map/2", do: Enum.flat_map(@list, fn x -> [x, x + 1] end)
  # bench "flat_map/2", do: flat_map[@list, fn x -> [x, x + 1] end)

  bench "Enum.count/1", do: Enum.count(@list)

  bench "Enum.count/1", do: Enum.count(@list)

  bench "count/1",  do: count(@list)
  bench "length/1", do: length(@list)

  bench "empty?/1",  do: empty?(@list)
  bench "null?/1",   do: null?(@list)

  bench "Enum.member?/2", do: Enum.member?(@list, 99)
  bench "member?/2", do: member?(@list, 99)

  bench "Enum.max/1", do: Enum.max(@list)
  bench "max/1", do: max(@list)

  bench "Enum.max_by/2", do: Enum.max_by(@list, fn(x) -> Integer.mod(x, 3) end) # Cheating a bit
  bench "max/2", do: max(@list, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  bench "Enum.min/1", do: Enum.min(@list)
  bench "min/1", do: min(@list)

  bench "Enum.min_by/2", do: Enum.min_by(@list, fn(x) -> Integer.mod(x, 3) end) # Cheating a bit
  bench "min/2", do: min(@list, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  bench "Enum.sum/1", do: Enum.sum(@list)
  bench "sum/1", do: sum(@list)

  bench "&Enum.reduce(&1, &*/2)", do: Enum.reduce(@list, &*/2)
  bench "product/1", do: product(@list)

  bench "Enum.random/1" do
    Enum.random(@list)
    true # get Benchfella to match on multiple runs
  end

  bench "random/1" do
    random(@list)
    true # get Benchfella to match on multiple runs
  end

  bench "fold/1",     do: fold(@list)
  bench "fold_map/2", do: fold_map(@list, fn x -> [x, x + 1] end)

  bench "Enum.map_reduce/3 + []" do
    @list
    |> Enum.map_reduce([], fn(x, acc) -> {[x + 1 | acc], nil} end)
    |> elem(0)
  end

  bench "left_fold/2", do: left_fold(@list, fn(acc, x) -> [x + 1 | acc] end)
  bench "left_fold/3", do: left_fold(@list, @list, fn(acc, x) -> [x + 1 | acc] end)

  bench "List.foldl/3 + []", do: List.foldl(@list, [], fn(x, acc) -> [x + 1 | acc]end)
  bench "List.foldl/3", do: List.foldl(@list, @list, fn(x, acc) -> [x + 1 | acc] end)

  bench "right_fold/3 + []", do: right_fold(@list, [], fn(x, acc) -> [x + 1 | acc] end)
  bench "right_fold/3", do: right_fold(@list, @list, fn(x, acc) -> [x + 1 | acc] end)

  bench "Enum.reduce/2", do: Enum.reduce(@list, fn(x, acc) -> [x + 1 | acc] end)
  bench "Enum.reduce/3", do: Enum.reduce(@list, @list, fn(x, acc) -> [x + 1 | acc] end)

  bench "List.foldr/3 + []", do: List.foldr(@list, [], fn(x, acc) -> [x + 1 | acc]end)
  bench "List.foldr/3", do: List.foldr(@list, @list, fn(x, acc) -> [x + 1 | acc] end)

  bench "size/1", do: size(@list)

  # bench "then_sequence/1", do: then_sequence(@list)

  bench "Enum.to_list/1", do: Enum.to_list(@list)
  bench "to_list/1",      do: to_list(@list)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list 0..1_000_000 |> Enum.to_list()

  # bench "$$$ all?/1"
  # bench "$$$ all?/2"

  # bench "$$$ any?/1"
  # bench "$$$ any?/2"

  # bench "$$$ concat/1"
  # bench "$$$ concat_map/2"

  # bench "$$$ count/1"

  # bench "$$$ empty?/1"

  # bench "$$$ fold/1"
  # bench "$$$ fold_map/2"

  # bench "$$$ left_fold/2"
  # bench "$$$ left_fold/3"

  # bench "$$$ length/1"

  # bench "$$$ max/1"
  # bench "$$$ max/2"

  # bench "$$$ member/2"

  # bench "$$$ min/1"
  # bench "$$$ min/2"

  # bench "$$$ null?/2"

  # bench "$$$ product/1"

  # bench "$$$ random/1"

  # bench "$$$ right_fold/2"
  # bench "$$$ right_fold/3"

  # bench "$$$ size/1"

  # bench "$$$ sum/1"

  # bench "$$$ then_sequence/1"
  # bench "$$$ to_list/1"

end
