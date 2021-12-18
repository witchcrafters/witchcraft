defmodule Witchcraft.Apply.FunBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Apply

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  defp fun(x, y, z), do: x + y * z
  defp fun(z), do: fn x -> fn y -> x + y + z end end

  defp slow_fun(z) do
    Process.sleep(20)

    fn x, y ->
      x + y * z
    end
  end

  defp slow_fun(x, y, z) do
    Process.sleep(20)
    x + y * z
  end

  #########
  # Apply #
  #########

  # ==== #
  # Data #
  # ==== #

  bench("data convey/2", do: fn x -> fun(x) end |> convey(fn x -> fun(x) end))
  bench("data ap/2", do: fn x -> fun(x) end |> ap(fn x -> fun(x) end))

  bench("data <<~/2", do: fn x -> fun(x) end <<~ fn x -> fun(x) end)
  bench("data <<~/2", do: fn x -> fun(x) end <<~ fn x -> fun(x) end)

  bench("data ~>>/2", do: fn x -> fun(x) end ~>> fn x -> fun(x) end)
  bench("data ~>>/2", do: fn x -> fun(x) end ~>> fn x -> fun(x) end)

  bench("data provide/2", do: fn x -> fun(x) end |> provide(fn x -> fun(x) end))
  bench("data supply/2", do: fn x -> fun(x) end |> supply(fn x -> fun(x) end))

  bench("data lift/3", do: lift(fn x -> fun(x) end, fn x -> fun(x) end, &+/2))

  bench("data lift/4",
    do: lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x, y, z -> x + y + z end)
  )

  bench("data lift/5",
    do:
      lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end, fn w, x, y, z ->
        w + x + y + z
      end)
  )

  bench("data over/3", do: over(&+/2, fn x -> fun(x) end, fn x -> fun(x) end))

  bench("data over/4",
    do: over(fn x, y, z -> x + y + z end, fn x -> fun(x) end, fn x -> fun(x) end)
  )

  bench("data over/5",
    do:
      over(fn w, x, y, z -> w + x + y + z end, fn x -> fun(x) end, fn x -> fun(x) end, fn x ->
        fun(x)
      end)
  )

  bench("following/2", do: fn x -> fun(x) end |> following(fn x -> fun(x) end))
  bench("then/2", do: fn x -> fun(x) end |> then(fn x -> fun(x) end))

  # ----- #
  # Async #
  # ----- #

  bench("data async_convey/2", do: fn x -> fun(x) end |> async_convey(fn x -> fun(x) end))
  bench("data async_ap/2", do: fn x -> fun(x) end |> async_ap(fn x -> fun(x) end))

  bench("async_lift/3", do: async_lift(fn x -> fun(x) end, fn x -> fun(x) end, &+/2))

  bench("async_lift/4",
    do: async_lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x, y, z -> x + y + z end)
  )

  bench("async_lift/5",
    do:
      async_lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end, fn w, x, y, z ->
        w + x + y + z
      end)
  )

  bench("async_over/3", do: async_over(&+/2, fn x -> fun(x) end, fn x -> fun(x) end))

  bench("async_over/4",
    do: async_over(fn x, y, z -> x + y + z end, fn x -> fun(x) end, fn x -> fun(x) end)
  )

  bench("async_over/5",
    do:
      async_over(
        fn w, x, y, z -> w + x + y + z end,
        fn x -> fun(x) end,
        fn x -> fun(x) end,
        fn x -> fun(x) end
      )
  )

  bench("!!! convey/2", do: fn x -> fun(x) end |> convey(fn y -> slow_fun(y) end))
  bench("!!! ap/2", do: fn y -> slow_fun(y) end |> ap(fn x -> fun(x) end))

  bench "!!! lift/3" do
    lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x, y ->
      Process.sleep(20)
      x + y
    end)
  end

  bench "!!! lift/4" do
    lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end, fn x, y, z ->
      Process.sleep(20)
      x + y + z
    end)
  end

  # also very slow, due to exponential complexity of multiple fun dimensions
  # 50^4 = 6_250_000 items to process
  bench "!!! lift/5" do
    lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end, fn w,
                                                                                            x,
                                                                                            y,
                                                                                            z ->
      Process.sleep(20)
      w + x + y + z
    end)
  end

  bench "!!! over/3" do
    fn x, y ->
      Process.sleep(20)
      x + y
    end
    |> over(fn x -> fun(x) end, fn x -> fun(x) end)
  end

  bench "!!! over/4" do
    fn x, y, z ->
      Process.sleep(20)
      x + y + z
    end
    |> over(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end)
  end

  # So slow
  bench "!!! over/5" do
    fn w, x, y, z ->
      Process.sleep(20)
      w + x + y + z
    end
    |> over(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end)
  end

  bench("!!! async_convey/2", do: fn x -> fun(x) end |> async_convey(fn y -> slow_fun(y) end))
  bench("!!! async_ap/2", do: fn y -> slow_fun(y) end |> async_ap(fn x -> fun(x) end))

  bench "!!! async_lift/3" do
    async_lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x, y ->
      Process.sleep(20)
      x + y
    end)
  end

  bench "!!! async_lift/4" do
    async_lift(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end, fn x, y, z ->
      Process.sleep(20)
      x + y + z
    end)
  end

  bench "!!! async_lift/5" do
    async_lift(
      fn x -> fun(x) end,
      fn x -> fun(x) end,
      fn x -> fun(x) end,
      fn x -> fun(x) end,
      fn w, x, y, z ->
        Process.sleep(20)
        w + x + y + z
      end
    )
  end

  bench "!!! async_over/3" do
    fn x, y ->
      Process.sleep(20)
      x + y
    end
    |> async_over(fn x -> fun(x) end, fn x -> fun(x) end)
  end

  bench "!!! async_over/4" do
    fn x, y, z ->
      Process.sleep(20)
      x + y + z
    end
    |> async_over(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end)
  end

  bench "!!! async_over/5" do
    fn w, x, y, z ->
      Process.sleep(20)
      w + x + y + z
    end
    |> async_over(fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end, fn x -> fun(x) end)
  end
end
