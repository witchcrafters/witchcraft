defmodule Witchcraft.Foldable.BitStringBench do
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

  @string 0..10 |> Enum.to_list() |> inspect()

  ############
  # Foldable #
  ############

  bench("flat_map/2", do: flat_map(@string, fn x -> [x, x <> x] end))

  bench("Kernel.string_size/1", do: String.length(@string))

  bench("count/1", do: count(@string))
  bench("length/1", do: length(@string))

  bench("empty?/1", do: empty?(@string))
  bench("null?/1", do: null?(@string))

  bench("member?/2", do: member?(@string, 99))

  bench("max/1", do: max(@string))
  bench("max/2", do: max(@string, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("min/1", do: min(@string))
  bench("min/2", do: min(@string, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("sum/1", do: sum(@string))
  bench("product/1", do: product(@string))

  bench "random/1" do
    random(@string)
    # get Benchfella to match on multiple runs
    true
  end

  bench("fold/1", do: fold(@string))
  bench("fold_map/2", do: fold_map(@string, fn x -> [x, x + 1] end))

  bench("left_fold/2", do: left_fold(@string, fn acc, x -> "#{x}-#{acc}" end))
  bench("left_fold/3", do: left_fold(@string, @string, fn acc, x -> "#{x}-#{acc}" end))

  bench("right_fold/2", do: right_fold(@string, fn x, acc -> "#{x}-#{acc}" end))
  bench("right_fold/3", do: right_fold(@string, @string, fn acc, x -> "#{x}-#{acc}" end))

  bench("size/1", do: size(@string))

  bench("String.to_charlist/1", do: String.to_charlist(@string))
  bench("to_list/1", do: to_list(@string))

  # ---------- #
  # Large Data #
  # ---------- #

  @big_string 0..10_000 |> Enum.to_list() |> inspect()

  bench("$$$ flat_map/2", do: flat_map(@big_string, fn x -> [x, x <> x] end))

  bench("$$$ Kernel.string_size/1", do: String.length(@big_string))

  bench("$$$ count/1", do: count(@big_string))
  bench("$$$ length/1", do: length(@big_string))

  bench("$$$ empty?/1", do: empty?(@big_string))
  bench("$$$ null?/1", do: null?(@big_string))

  bench("$$$ member?/2", do: member?(@big_string, 99))

  bench("$$$ max/1", do: max(@big_string))
  bench("$$$ max/2", do: max(@big_string, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("$$$ min/1", do: min(@big_string))
  bench("$$$ min/2", do: min(@big_string, by: fn x, y -> Integer.mod(x, 3) > y end))

  bench("$$$ sum/1", do: sum(@big_string))
  bench("$$$ product/1", do: product(@big_string))

  bench "$$$ random/1" do
    random(@big_string)
    # get Benchfella to match on multiple runs
    true
  end

  bench("$$$ fold/1", do: fold(@big_string))
  bench("$$$ fold_map/2", do: fold_map(@big_string, fn x -> [x, x + 1] end))

  bench("$$$ left_fold/2", do: left_fold(@big_string, fn acc, x -> "#{x}-#{acc}" end))

  bench("$$$ left_fold/3", do: left_fold(@big_string, @big_string, fn acc, x -> "#{x}-#{acc}" end))

  bench("$$$ right_fold/2", do: right_fold(@big_string, fn x, acc -> "#{x}-#{acc}" end))

  bench("$$$ right_fold/3",
    do: right_fold(@big_string, @big_string, fn acc, x -> "#{x}-#{acc}" end)
  )

  bench("$$$ size/1", do: size(@big_string))

  bench("$$$ String.to_charlist/1", do: String.to_charlist(@big_string))
  bench("$$$ to_list/1", do: to_list(@big_string))
end
