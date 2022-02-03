defmodule Witchcraft.Setoid.BitStringBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Setoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @string_a "asdfghjkl"
  @string_b "poiuytrewq"

  ##########
  # Kernel #
  ##########

  bench("Kernel.==/2", do: Kernel.==(@string_a, @string_b))
  bench("Kernel.!=/2", do: Kernel.!=(@string_a, @string_b))

  ##########
  # Setoid #
  ##########

  bench("equivalent?/2", do: equivalent?(@string_a, @string_b))
  bench("nonequivalent?/2", do: nonequivalent?(@string_a, @string_b))

  # --------- #
  # Operators #
  # --------- #

  bench("==/2", do: @string_a == @string_b)
  bench("!=/2", do: @string_a != @string_b)

  # ---------- #
  # Large Data #
  # ---------- #

  @big_string_a fn -> Enum.random(["hhh", "k", "8", "hello", "ください", "z", "?:!"]) end
                |> Stream.repeatedly()
                |> Enum.take(:rand.uniform(10_000))

  @big_string_b fn -> Enum.random(["abc", "z", "please", "!", "パン", "sure", "&"]) end
                |> Stream.repeatedly()
                |> Enum.take(:rand.uniform(10_000))

  bench("$$$ Kernel.==/2", do: Kernel.==(@big_string_a, @big_string_b))
  bench("$$$ Kernel.!=/2", do: Kernel.!=(@big_string_a, @big_string_b))

  bench("$$$ ==/2", do: @big_string_a == @big_string_b)
  bench("$$$ !=/2", do: @big_string_a != @big_string_b)
end
