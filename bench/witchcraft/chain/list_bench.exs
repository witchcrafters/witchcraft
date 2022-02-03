defmodule Witchcraft.Chain.ListBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Chain

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list_a 1..10 |> Enum.to_list() |> Enum.shuffle()
  @list_b 9..99 |> Enum.to_list() |> Enum.shuffle()

  #########
  # Chain #
  #########

  bench "chain/1" do
    chain do
      a <- @list_a
      b <- @list_b
      [a * b]
    end
  end

  bench "chain/2" do
    chain(@list_a, fn a ->
      chain(@list_b, fn b ->
        [a * b]
      end)
    end)
  end

  bench "draw/2" do
    fn a ->
      fn b ->
        [a * b]
      end
      |> draw(@list_b)
    end
    |> draw(@list_a)
  end

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..1_000 |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999 |> Enum.to_list() |> Enum.shuffle()

  bench "$$$ chain/2" do
    chain(@big_list_a, fn a ->
      chain(@big_list_b, fn b ->
        [a * b]
      end)
    end)
  end

  bench "$$$ draw/2" do
    fn a ->
      fn b ->
        [a * b]
      end
      |> draw(@big_list_b)
    end
    |> draw(@big_list_a)
  end

  # ------------ #
  # Deep Nesting #
  # ------------ #

  bench "deep chain/2" do
    chain(@list_a, fn a ->
      chain(@list_b, fn _ ->
        chain(@list_a, fn _ ->
          chain(@list_b, fn b ->
            chain(@list_a, fn _ ->
              [a * b]
            end)
          end)
        end)
      end)
    end)
  end

  bench "deep draw/2" do
    fn a ->
      fn _ ->
        fn _ ->
          fn b ->
            fn _ ->
              [a * b]
            end
            |> draw(@list_a)
          end
          |> draw(@list_b)
        end
        |> draw(@list_a)
      end
      |> draw(@list_b)
    end
    |> draw(@list_a)
  end
end
