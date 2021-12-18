defmodule Witchcraft.Monad.ListBench do
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

  @list_a 1..10 |> Enum.to_list() |> Enum.shuffle()
  @list_b 9..99 |> Enum.to_list() |> Enum.shuffle()

  #########
  # Monad #
  #########

  bench "monad/2" do
    monad [] do
      a <- @list_a
      b <- @list_b
      return(a * b)
    end
  end

  bench "async/2" do
    async [] do
      a <- @list_a
      b <- @list_b
      return(a * b)
    end
  end

  bench "async_chain/2" do
    async_chain(@list_a, fn a ->
      async_chain(@list_b, fn b ->
        [a * b]
      end)
    end)
  end

  bench "async_draw/2" do
    async_draw(fn a ->
      async_draw(fn b ->
        [a * b]
      end, @list_b)
    end, @list_a)
  end

  # ----- #
  # Async #
  # ----- #

  bench "!!! Enum.flat_map/2" do
    Enum.flat_map(@list_a, fn a ->
      Process.sleep(50)
      Enum.flat_map(@list_b, fn b ->
        Process.sleep(50)
        [a * b]
      end)
    end)
  end

  bench "!!! chain/2" do
    chain(@list_a, fn a ->
      Process.sleep(50)
      chain(@list_b, fn b ->
        Process.sleep(50)
        [a * b]
      end)
    end)
  end

  bench "!!! draw/2" do
    draw(fn a ->
      Process.sleep(50)
      draw(fn b ->
        Process.sleep(50)
        [a * b]
      end, @list_b)
    end, @list_a)
  end

  bench "!!! async_chain/2" do
    async_chain(@list_a, fn a ->
      Process.sleep(50)
      async_chain(@list_b, fn b ->
        Process.sleep(50)
        [a * b]
      end)
    end)
  end

  bench "!!! async_draw/2" do
    async_draw(fn a ->
      Process.sleep(50)
      async_draw(fn b ->
        Process.sleep(50)
        [a * b]
      end, @list_b)
    end, @list_a)
  end

  # ---------- #
  # Large Data #
  # ---------- #

  @big_list_a 0..1_000 |> Enum.to_list() |> Enum.shuffle()
  @big_list_b 99..999 |> Enum.to_list() |> Enum.shuffle()

  bench "$$$ monad/2" do
    monad [] do
      a <- @big_list_a
      b <- @big_list_b
      return(a * b)
    end
  end

  bench "$$$ async/2" do
    async [] do
      a <- @big_list_a
      b <- @big_list_b
      return(a * b)
    end
  end

end
