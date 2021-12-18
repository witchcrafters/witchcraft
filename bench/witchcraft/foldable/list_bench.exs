defmodule Witchcraft.Foldable.ListBench do
  @moduledoc false

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

  bench("Enum.all?/1", do: Enum.all?([true, true, true, true, false]))

  bench("all?/1", do: all?([true, true, true, true, true, false]))
  bench("all?/2", do: all?(@list, fn x -> x > 5 end))

  bench("Enum.any?/1", do: Enum.any?([true, true, true, true, false]))

  bench("any?/1", do: any?([true, true, true, true, true, false]))
  bench("any?/2", do: any?(@list, fn x -> x > 5 end))

  bench("List.flatten/1", do: List.flatten([@list, @list, @list]))
  bench("flatten/1", do: flatten([@list, @list, @list]))

  bench("Enum.flat_map/2", do: Enum.flat_map(@list, fn x -> [x, x + 1] end))
  bench("flat_map/2", do: flat_map(@list, fn x -> [x, x + 1] end))

  bench("Enum.count/1", do: Enum.count(@list))

  bench("count/1", do: count(@list))
  bench("length/1", do: length(@list))

  bench("empty?/1", do: empty?(@list))
  bench("null?/1", do: null?(@list))

  bench("Enum.member?/2", do: Enum.member?(@list, 99))
  bench("member?/2", do: member?(@list, 99))

  bench("Enum.max/1", do: Enum.max(@list))
  bench("max/1", do: max(@list))

  # Cheating a bit
  bench("Enum.max_by/2", do: Enum.max_by(@list, fn x -> Integer.mod(x, 3) end))
  bench("max/2", do: max(@list, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("Enum.min/1", do: Enum.min(@list))
  bench("min/1", do: min(@list))

  # Cheating a bit
  bench("Enum.min_by/2", do: Enum.min_by(@list, fn x -> Integer.mod(x, 3) end))
  bench("min/2", do: min(@list, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("Enum.sum/1", do: Enum.sum(@list))
  bench("sum/1", do: sum(@list))

  bench("&Enum.reduce(&1, &*/2)", do: Enum.reduce(@list, &*/2))
  bench("product/1", do: product(@list))

  bench "Enum.random/1" do
    Enum.random(@list)
    # get Benchfella to match on multiple runs
    true
  end

  bench "random/1" do
    random(@list)
    # get Benchfella to match on multiple runs
    true
  end

  bench("fold/1", do: fold(@list))
  bench("fold_map/2", do: fold_map(@list, fn x -> [x, x + 1] end))

  bench "Enum.map_reduce/3 + []" do
    @list
    |> Enum.map_reduce([], fn x, acc -> {[x + 1 | acc], nil} end)
    |> elem(0)
  end

  bench("left_fold/2", do: left_fold(@list, fn acc, x -> [x + 1 | acc] end))
  bench("left_fold/3", do: left_fold(@list, @list, fn acc, x -> [x + 1 | acc] end))

  bench("List.foldl/3 + []", do: List.foldl(@list, [], fn x, acc -> [x + 1 | acc] end))
  bench("List.foldl/3", do: List.foldl(@list, @list, fn x, acc -> [x + 1 | acc] end))

  bench("right_fold/3 + []", do: right_fold(@list, [], fn x, acc -> [x + 1 | acc] end))
  bench("right_fold/3", do: right_fold(@list, @list, fn x, acc -> [x + 1 | acc] end))

  bench("Enum.reduce/2", do: Enum.reduce(@list, fn x, acc -> [x + 1 | acc] end))
  bench("Enum.reduce/3", do: Enum.reduce(@list, @list, fn x, acc -> [x + 1 | acc] end))

  bench("List.foldr/3 + []", do: List.foldr(@list, [], fn x, acc -> [x + 1 | acc] end))
  bench("List.foldr/3", do: List.foldr(@list, @list, fn x, acc -> [x + 1 | acc] end))

  bench("size/1", do: size(@list))

  bench("then_sequence/1", do: then_sequence([@list, @list, @list]))

  bench("Enum.to_list/1", do: Enum.to_list(@list))
  bench("to_list/1", do: to_list(@list))

  bench "then_traverse/2" do
    @list
    |> then_traverse(fn x -> [x + 1] end)
    |> then_traverse(fn y -> [y, y] end)
  end

  bench "then_through/2" do
    fn y -> [y, y] end |> then_through(fn x -> [x + 1] end |> then_through(@list))
  end

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list Enum.to_list(0..10_000)
  @med_list Enum.to_list(0..250)
  @bools Enum.map(@big_list, fn _ -> Enum.random([true, false]) end)
  @nested fn -> [1, 2, 3] end |> Stream.repeatedly() |> Enum.take(10)

  bench("$$$ Enum.all?/1", do: Enum.all?(@bools))

  bench("$$$ all?/1", do: all?(@bools))
  bench("$$$ all?/2", do: all?(@big_list, fn x -> x > 5 end))

  bench("$$$ Enum.any?/1", do: Enum.any?(@bools))

  bench("$$$ any?/1", do: any?([true, true, true, true, true, false]))
  bench("$$$ any?/2", do: any?(@big_list, fn x -> x > 5 end))

  bench("$$$ List.flatten/1",
    do: List.flatten([@big_list, @big_list, @big_list, @big_list, @big_list])
  )

  bench("$$$ flatten/1", do: flatten([@big_list, @big_list, @big_list, @big_list, @big_list]))

  bench("$$$ Enum.flat_map/2", do: Enum.flat_map(@big_list, fn x -> [x, x + 1] end))
  bench("$$$ flat_map/2", do: flat_map(@big_list, fn x -> [x, x + 1] end))

  bench("$$$ Enum.count/1", do: Enum.count(@big_list))

  bench("$$$ Enum.count/1", do: Enum.count(@big_list))

  bench("$$$ count/1", do: count(@big_list))
  bench("$$$ length/1", do: length(@big_list))

  bench("$$$ empty?/1", do: empty?(@big_list))
  bench("$$$ null?/1", do: null?(@big_list))

  bench("$$$ Enum.member?/2", do: Enum.member?(@big_list, 99))
  bench("$$$ member?/2", do: member?(@big_list, 99))

  bench("$$$ Enum.max/1", do: Enum.max(@big_list))
  bench("$$$ max/1", do: max(@big_list))

  # Cheating a bit
  bench("$$$ Enum.max_by/2", do: Enum.max_by(@big_list, fn x -> Integer.mod(x, 3) end))
  bench("$$$ max/2", do: max(@big_list, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("$$$ Enum.min/1", do: Enum.min(@big_list))
  bench("$$$ min/1", do: min(@big_list))

  # Cheating a bit
  bench("$$$ Enum.min_by/2", do: Enum.min_by(@big_list, fn x -> Integer.mod(x, 3) end))
  bench("$$$ min/2", do: min(@big_list, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("$$$ Enum.sum/1", do: Enum.sum(@big_list))
  bench("$$$ sum/1", do: sum(@big_list))

  bench("$$$ &Enum.reduce(&1, &*/2)", do: Enum.reduce(@big_list, &*/2))
  bench("$$$ product/1", do: product(@big_list))

  bench "$$$ Enum.random/1" do
    Enum.random(@big_list)
    # get Benchfella to match on multiple runs
    true
  end

  bench "$$$ random/1" do
    random(@big_list)
    # get Benchfella to match on multiple runs
    true
  end

  bench("$$$ fold/1", do: fold(@big_list))
  bench("$$$ fold_map/2", do: fold_map(@big_list, fn x -> [x, x + 1] end))

  bench "$$$ Enum.map_reduce/3 + []" do
    @big_list
    |> Enum.map_reduce([], fn x, acc -> {[x + 1 | acc], nil} end)
    |> elem(0)
  end

  bench("$$$ left_fold/2", do: left_fold(@big_list, fn acc, x -> [x + 1 | acc] end))
  bench("$$$ left_fold/3", do: left_fold(@big_list, @big_list, fn acc, x -> [x + 1 | acc] end))

  bench("$$$ List.foldl/3 + []", do: List.foldl(@big_list, [], fn x, acc -> [x + 1 | acc] end))
  bench("$$$ List.foldl/3", do: List.foldl(@big_list, @big_list, fn x, acc -> [x + 1 | acc] end))

  bench("$$$ right_fold/3 + []", do: right_fold(@big_list, [], fn x, acc -> [x + 1 | acc] end))
  bench("$$$ right_fold/3", do: right_fold(@big_list, @big_list, fn x, acc -> [x + 1 | acc] end))

  bench("$$$ Enum.reduce/2", do: Enum.reduce(@big_list, fn x, acc -> [x + 1 | acc] end))

  bench("$$$ Enum.reduce/3", do: Enum.reduce(@big_list, @big_list, fn x, acc -> [x + 1 | acc] end))

  bench("$$$ List.foldr/3 + []", do: List.foldr(@big_list, [], fn x, acc -> [x + 1 | acc] end))
  bench("$$$ List.foldr/3", do: List.foldr(@big_list, @big_list, fn x, acc -> [x + 1 | acc] end))

  bench("$$$ size/1", do: size(@big_list))

  bench("$$$ med then_sequence/1", do: then_sequence([@med_list, @med_list, @med_list]))
  bench("$$$ sml then_sequence/1", do: then_sequence(@nested))

  bench("$$$ Enum.to_list/1", do: Enum.to_list(@big_list))
  bench("$$$ to_list/1", do: to_list(@big_list))

  bench "$$$ then_traverse/2" do
    @big_list
    |> then_traverse(fn x -> [x + 1] end)
    |> then_traverse(fn y -> [y, y] end)
  end

  bench "$$$ then_through/2" do
    fn y -> [y, y] end |> then_through(fn x -> [x + 1] end |> then_through(@big_list))
  end
end
