defmodule Witchcraft.Foldable.BitStringBench do
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

  @string 0..10 |> Enum.to_list() |> inspect()

  ############
  # Foldable #
  ############

  bench "flat_map/2", do: flat_map(@string, fn x -> [x, x <> x] end)

  bench "Kernel.string_size/1", do: String.length(@string)

  bench "count/1",  do: count(@string)
  bench "length/1", do: length(@string)

  bench "empty?/1",  do: empty?(@string)
  bench "null?/1",   do: null?(@string)

  bench "member?/2", do: member?(@string, 99)

  bench "max/1", do: max(@string)
  bench "max/2", do: max(@string, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  bench "min/1", do: min(@string)
  bench "min/2", do: min(@string, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  bench "sum/1", do: sum(@string)
  bench "product/1", do: product(@string)

  bench "random/1" do
    random(@string)
    true # get Benchfella to match on multiple runs
  end

  bench "fold/1",     do: fold(@string)
  bench "fold_map/2", do: fold_map(@string, fn x -> [x, x + 1] end)

  bench "left_fold/2", do: left_fold(@string, fn(acc, x) -> "#{x}-#{acc}" end)
  # bench "left_fold/3", do: left_fold(@string, @string, fn(acc, x) -> {x + 1 , acc} end)

  bench "right_fold/2", do: right_fold(@string, fn(x, acc) -> "#{x}-#{acc}" end)
  # bench "right_fold/3 + {}", do: right_fold(@string, {1, 2}, fn(x, acc) -> {x + 1, acc} end)
  # bench "right_fold/3", do: right_fold(@string, @string, fn(x, acc) -> {x + 1, acc} end)

  bench "size/1", do: size(@string)

  # bench "then_sequence/1", do: then_sequence({{1, 2, 3}, {4, 5, 6}, {7, 8, 9}})

  bench "String.to_charlist/1", do: String.to_charlist(@string)
  bench "to_list/1", do: to_list(@string)

  # ---------- #
  # Large Data #
  # ---------- #

  # @big_string 0..10_000 |> Enum.to_list() |> List.to_string()
  # @med_string 0..250 |> Enum.to_list() |> List.to_string()

  # @bools  0..250 |> Enum.to_list() |> map(fn _ -> Enum.random([true, false]) end) |> List.to_string()
  # @nested fn -> {1, 2, 3} end |> Stream.repeatedly() |> Enum.take(10) |> List.to_string()

  # bench "$$$ Enum.all?/1", do: @bools |> String.to_list() |> Enum.all?()

  # bench "$$$ all?/1", do: all?(@bools)
  # bench "$$$ all?/2", do: all?(@big_string, fn x -> x > 5 end)

  # bench "$$$ any?/1", do: any?(@bools)
  # bench "$$$ any?/2", do: any?(@big_string, fn x -> x > 5 end)

  # bench "$$$ flatten/1",  do: flatten(@nested)

  # bench "$$$ flat_map/2", do: flat_map(@big_string, fn x -> [x, x + 1] end)

  # bench "$$$ Kernel.string_size/1", do: string_size(@big_string)

  # bench "$$$ count/1",  do: count(@big_string)
  # bench "$$$ length/1", do: length(@big_string)

  # bench "$$$ empty?/1",  do: empty?(@big_string)
  # bench "$$$ null?/1",   do: null?(@big_string)

  # bench "$$$ member?/2", do: member?(@big_string, 99)

  # bench "$$$ max/1", do: max(@big_string)
  # bench "$$$ max/2", do: max(@big_string, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  # bench "$$$ min/1", do: min(@big_string)
  # bench "$$$ min/2", do: min(@big_string, by: fn(x, y) -> Integer.mod(x, 3) > y end)

  # bench "$$$ sum/1", do: sum(@big_string)
  # bench "$$$ product/1", do: product(@big_string)

  # bench "$$$ random/1" do
  #   random(@big_string)
  #   true # get Benchfella to match on multiple runs
  # end

  # bench "$$$ fold/1",     do: fold(@big_string)
  # bench "$$$ fold_map/2", do: fold_map(@big_string, fn x -> {x, x + 1} end)

  # bench "$$$ left_fold/2", do: left_fold(@big_string, fn(acc, x) -> {x + 1 , acc} end)
  # bench "$$$ left_fold/3", do: left_fold(@big_string, @big_string, fn(acc, x) -> {x + 1 , acc} end)

  # bench "$$$ right_fold/3 + {}", do: right_fold(@big_string, {1, 2}, fn(x, acc) -> {x + 1, acc} end)
  # bench "$$$ right_fold/3", do: right_fold(@big_string, @big_string, fn(x, acc) -> {x + 1, acc} end)

  # bench "$$$ size/1", do: size(@big_string)

  # bench "$$$ then_sequence/1", do: then_sequence(@nested)

  # bench "$$$ to_list/1", do: to_list(@big_string)

end
