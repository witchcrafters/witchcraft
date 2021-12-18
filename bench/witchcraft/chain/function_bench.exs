defmodule Witchcraft.Chain.FunctionBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Chain

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  def fun_a(x), do: "#{inspect x}-#{inspect x}"
  def fun_b(y), do: "#{inspect y}!#{inspect y}"

  #########
  # Chain #
  #########

  bench "chain/1" do
    chain do
      a <- &fun_a/1
      b <- &fun_b/1
      fn x -> x |> a.() |> b.() end
    end
  end

  bench "chain/2" do
    chain(&fun_a/1, fn a ->
      chain(&fun_b/1, fn b ->
        fn x -> x |> a.() |> b.() end
      end)
    end)
  end

  bench "draw/2" do
    fn a ->
      fn b ->
        fn x -> x |> a.() |> b.() end
      end
      |> draw(&fun_b/1)
    end
    |> draw(&fun_a/1)
  end

  # ------------ #
  # Deep Nesting #
  # ------------ #

  bench "deep chain/2" do
    chain(&fun_a/1, fn a ->
      chain(&fun_b/1, fn _ ->
        chain(&fun_b/1, fn _ ->
          chain(&fun_b/1, fn _ ->
            chain(&fun_b/1, fn _ ->
              chain(&fun_b/1, fn _ ->
                chain(&fun_b/1, fn _ ->
                  chain(&fun_a/1, fn _ ->
                    chain(&fun_b/1, fn b ->
                      chain(&fun_a/1, fn _ ->
                        fn x -> x |> a.() |> b.() end
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
                        fn x -> x |> a.() |> b.() end
                      end
                      |> draw(&fun_a/1)
                    end
                    |> draw(&fun_b/1)
                  end
                  |> draw(&fun_a/1)
                end
                |> draw(&fun_b/1)
              end
              |> draw(&fun_b/1)
            end
            |> draw(&fun_b/1)
          end
          |> draw(&fun_b/1)
        end
        |> draw(&fun_b/1)
      end
      |> draw(&fun_b/1)
    end
    |> draw(&fun_a/1)
  end
end
