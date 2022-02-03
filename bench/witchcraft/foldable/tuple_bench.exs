defmodule Witchcraft.Foldable.TupleBench do
  @moduledoc false

  require Integer

  use Benchfella
  use Witchcraft.Foldable
  use Witchcraft.Functor

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple 0..10 |> Enum.to_list() |> List.to_tuple()

  ############
  # Foldable #
  ############

  bench("Enum.all?/1", do: {true, true, true, true, false} |> Tuple.to_list() |> Enum.all?())

  bench("all?/1", do: all?({true, true, true, true, true, false}))
  bench("all?/2", do: all?(@tuple, fn x -> x > 5 end))

  bench("any?/1", do: any?({true, true, true, true, true, false}))
  bench("any?/2", do: any?(@tuple, fn x -> x > 5 end))

  bench("flatten/1", do: flatten({[1, 2, 3], [4, 5, 6], [7, 8, 9]}))

  bench("flat_map/2", do: flat_map(@tuple, fn x -> [x, x + 1] end))

  bench("Kernel.tuple_size/1", do: tuple_size(@tuple))

  bench("count/1", do: count(@tuple))
  bench("length/1", do: length(@tuple))

  bench("empty?/1", do: empty?(@tuple))
  bench("null?/1", do: null?(@tuple))

  bench("member?/2", do: member?(@tuple, 99))

  bench("max/1", do: max(@tuple))
  bench("max/2", do: max(@tuple, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("min/1", do: min(@tuple))
  bench("min/2", do: min(@tuple, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("sum/1", do: sum(@tuple))
  bench("product/1", do: product(@tuple))

  bench "random/1" do
    random(@tuple)
    # get Benchfella to match on multiple runs
    true
  end

  bench("fold/1", do: fold(@tuple))
  bench("fold_map/2", do: fold_map(@tuple, fn x -> {x, x + 1} end))

  bench("left_fold/2", do: left_fold(@tuple, fn acc, x -> {x + 1, acc} end))
  bench("left_fold/3", do: left_fold(@tuple, @tuple, fn acc, x -> {x + 1, acc} end))

  bench("right_fold/3 + {}", do: right_fold(@tuple, {1, 2}, fn x, acc -> {x + 1, acc} end))
  bench("right_fold/3", do: right_fold(@tuple, @tuple, fn x, acc -> {x + 1, acc} end))

  bench("size/1", do: size(@tuple))

  bench("then_sequence/1", do: then_sequence({{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}))

  bench("Tuple.to_list/1", do: Tuple.to_list(@tuple))
  bench("to_list/1", do: to_list(@tuple))

  bench "then_traverse/2" do
    @tuple
    |> then_traverse(fn x -> Tuple.duplicate(x, 11) end)
    |> then_traverse(fn y -> Tuple.duplicate(y, 11) end)
  end

  bench "then_through/2" do
    fn y -> Tuple.duplicate(y, 11) end
    |> then_through(
      fn x -> Tuple.duplicate(x, 11) end
      |> then_through(@tuple)
    )
  end

  # ---------- #
  # Large Data #
  # ---------- #

  @big_tuple 0..10_000 |> Enum.to_list() |> List.to_tuple()
  @med_tuple 0..250 |> Enum.to_list() |> List.to_tuple()

  @bools 0..250
         |> Enum.to_list()
         |> map(fn _ -> Enum.random([true, false]) end)
         |> List.to_tuple()
  @nested fn -> [1, 2, 3] end |> Stream.repeatedly() |> Enum.take(10) |> List.to_tuple()

  bench("$$$ Enum.all?/1", do: @bools |> Tuple.to_list() |> Enum.all?())

  bench("$$$ all?/1", do: all?(@bools))
  bench("$$$ all?/2", do: all?(@big_tuple, fn x -> x > 5 end))

  bench("$$$ any?/1", do: any?(@bools))
  bench("$$$ any?/2", do: any?(@big_tuple, fn x -> x > 5 end))

  bench("$$$ flatten/1", do: flatten(@nested))

  bench("$$$ flat_map/2", do: flat_map(@big_tuple, fn x -> [x, x + 1] end))

  bench("$$$ Kernel.tuple_size/1", do: tuple_size(@big_tuple))

  bench("$$$ count/1", do: count(@big_tuple))
  bench("$$$ length/1", do: length(@big_tuple))

  bench("$$$ empty?/1", do: empty?(@big_tuple))
  bench("$$$ null?/1", do: null?(@big_tuple))

  bench("$$$ member?/2", do: member?(@big_tuple, 99))

  bench("$$$ max/1", do: max(@big_tuple))
  bench("$$$ max/2", do: max(@big_tuple, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("$$$ min/1", do: min(@big_tuple))
  bench("$$$ min/2", do: min(@big_tuple, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("$$$ sum/1", do: sum(@big_tuple))
  bench("$$$ product/1", do: product(@big_tuple))

  bench "$$$ random/1" do
    random(@big_tuple)
    # get Benchfella to match on multiple runs
    true
  end

  bench("$$$ fold/1", do: fold(@big_tuple))
  bench("$$$ fold_map/2", do: fold_map(@big_tuple, fn x -> {x, x + 1} end))

  bench("$$$ left_fold/2", do: left_fold(@big_tuple, fn acc, x -> {x + 1, acc} end))
  bench("$$$ left_fold/3", do: left_fold(@big_tuple, @big_tuple, fn acc, x -> {x + 1, acc} end))

  bench("$$$ right_fold/3 + {}", do: right_fold(@big_tuple, {1, 2}, fn x, acc -> {x + 1, acc} end))

  bench("$$$ right_fold/3", do: right_fold(@big_tuple, @big_tuple, fn x, acc -> {x + 1, acc} end))

  bench("$$$ size/1", do: size(@big_tuple))

  bench("$$$ then_sequence/1", do: then_sequence(@nested))

  bench("$$$ to_list/1", do: to_list(@big_tuple))

  bench "$$$ then_traverse/2" do
    @med_tuple
    |> then_traverse(fn x -> Tuple.duplicate(x, 251) end)
    |> then_traverse(fn y -> Tuple.duplicate(y, 251) end)
  end

  bench "$$$ then_through/2" do
    fn y -> Tuple.duplicate(y, 251) end
    |> then_through(
      fn x -> Tuple.duplicate(x, 251) end
      |> then_through(@med_tuple)
    )
  end
end
