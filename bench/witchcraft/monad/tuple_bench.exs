defmodule Witchcraft.Monad.TupleBench do
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

  @tuple_a {42, 99}
  @tuple_b {13, 77}

  #########
  # Monad #
  #########

  bench "monad/2" do
    monad {0, 0} do
      a <- @tuple_a
      b <- @tuple_b
      return(a * b)
    end
  end

  bench "async/2" do
    async {0, 0} do
      a <- @tuple_a
      b <- @tuple_b
      return(a * b)
    end
  end

  bench "async_chain/2" do
    async_chain(@tuple_a, fn a ->
      async_chain(@tuple_b, fn b ->
        {a * b, a}
      end)
    end)
  end

  bench "async_draw/2" do
    async_draw(fn a ->
      async_draw(fn b ->
        {a * b, a}
      end, @tuple_b)
    end, @tuple_a)
  end

  # ----- #
  # Async #
  # ----- #

  bench "!!! chain/2" do
    chain(@tuple_a, fn a ->
      Process.sleep(50)
      chain(@tuple_b, fn b ->
        Process.sleep(50)
        {a * b, a}
      end)
    end)
  end

  bench "!!! draw/2" do
    draw(fn a ->
      Process.sleep(50)
      draw(fn b ->
        Process.sleep(50)
        {a * b, a}
      end, @tuple_b)
    end, @tuple_a)
  end

  bench "!!! async_chain/2" do
    async_chain(@tuple_a, fn a ->
      Process.sleep(50)
      async_chain(@tuple_b, fn b ->
        Process.sleep(50)
        {a * b, a}
      end)
    end)
  end

  bench "!!! async_draw/2" do
    async_draw(fn a ->
      Process.sleep(50)
      async_draw(fn b ->
        Process.sleep(50)
        {a * b, a}
      end, @tuple_b)
    end, @tuple_a)
  end

  # -------- #
  # Many Ops #
  # -------- #

  bench "$$$ monad/2" do
    monad {0, 0} do
      @tuple_b
      @tuple_a
      @tuple_b
      @tuple_a
      @tuple_b
      @tuple_a
      @tuple_b

      @tuple_a
      @tuple_b
      @tuple_a
      @tuple_b
      @tuple_a
      @tuple_b

      a <- @tuple_a
      b <- @tuple_b

      return(a * b)
    end
  end

end
