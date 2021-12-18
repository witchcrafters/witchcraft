defmodule Witchcraft.Monad.FunctionBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Monad
  use Quark

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  def fun(x), do: "#{inspect x}-#{inspect x}"

  #########
  # Monad #
  #########

  bench "monad/2" do
    monad fn -> nil end do
      &fun/1

      fn f ->
        fn g -> f <|> g <|> g <|> f end
      end

      fn h -> h <|> h end
    end
  end

  bench "async/2" do
    async fn -> nil end do
      &fun/1

      fn f ->
        fn g -> f <|> g <|> g <|> f end
      end

      fn h -> h <|> h end
    end
  end

  bench "async_chain/2" do
    (&fun/1)
    |> async_chain(fn f ->
      fn g -> f <|> g <|> g <|> f end
    end)
    |> async_chain(fn h -> h <|> h end)
  end

  bench "async_draw/2" do
    fn h ->h <|> h end
    |> async_draw((fn f ->
      fn g ->
        f <|> g <|> g <|> f
      end
    end
    |> async_draw(&fun/1)))
  end

end
