defmodule Witchcraft.Chain.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Chain

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple_a {42, 99}
  @tuple_b {13, 77}

  #########
  # Chain #
  #########

  bench "chain/1" do
    chain do
      a <- @tuple_a
      b <- @tuple_b
      {a * b, b - a}
    end
  end

  bench "chain/2" do
    chain(@tuple_a, fn a ->
      chain(@tuple_b, fn b ->
        {a * b, b - a}
      end)
    end)
  end

  bench "draw/2" do
    fn a ->
      fn b ->
        {a * b, b - a}
      end
      |> draw(@tuple_b)
    end
    |> draw(@tuple_a)
  end

  # ------------ #
  # Deep Nesting #
  # ------------ #

  bench "deep chain/2" do
    chain(@tuple_a, fn a ->
      chain(@tuple_b, fn _ ->
        chain(@tuple_b, fn _ ->
          chain(@tuple_b, fn _ ->
            chain(@tuple_b, fn _ ->
              chain(@tuple_b, fn _ ->
                chain(@tuple_b, fn _ ->
                  chain(@tuple_a, fn _ ->
                    chain(@tuple_b, fn b ->
                      chain(@tuple_a, fn _ ->
                        {a * b, b - a}
                      end)
                    end)
                  end)
                end)
              end)
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
          fn _ ->
            fn _ ->
              fn _ ->
                fn _ ->
                  fn _ ->
                    fn b ->
                      fn _ ->
                        {a * b, b - a}
                      end
                      |> draw(@tuple_a)
                    end
                    |> draw(@tuple_b)
                  end
                  |> draw(@tuple_a)
                end
                |> draw(@tuple_b)
              end
              |> draw(@tuple_b)
            end
            |> draw(@tuple_b)
          end
          |> draw(@tuple_b)
        end
        |> draw(@tuple_b)
      end
      |> draw(@tuple_b)
    end
    |> draw(@tuple_a)
  end
end
