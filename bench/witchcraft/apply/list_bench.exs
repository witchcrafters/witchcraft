defmodule Witchcraft.Apply.ListBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Apply

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list_a 0..10 |> Enum.to_list() |> Enum.shuffle()
  @list_b 0..25 |> Enum.to_list() |> Enum.shuffle()

  def fun_list_a do
    [&(&1 + 1), &(&1 * 10), &(&1 * 1), &(&1 - 4), &inspect/1]
  end

  def fun_list_b do
    @list_a |> replace(fn x -> "#{inspect(x)}-#{inspect(x)}" end)
  end

  def slow_fun_list_a do
    [
      fn x ->
        Process.sleep(20)
        x + 1
      end,
      fn x ->
        Process.sleep(20)
        x * 10
      end,
      fn x ->
        Process.sleep(20)
        x - 4
      end,
      fn x ->
        Process.sleep(20)
        inspect(x)
      end
    ]
  end

  def slow_fun_list_b do
    replace(@list_b, fn x ->
      Process.sleep(20)
      "#{inspect(x)}-#{inspect(x)}"
    end)
  end

  #########
  # Apply #
  #########

  # ==== #
  # Data #
  # ==== #

  bench("data convey/2", do: @list_a |> convey(fun_list_a()))
  bench("data ap/2", do: fun_list_a() |> ap(@list_b))

  bench("data <<~/2", do: fun_list_a() <<~ @list_a)
  bench("data <<~/2", do: fun_list_a() <<~ @list_a)

  bench("data ~>>/2", do: @list_a ~>> fun_list_a())
  bench("data ~>>/2", do: @list_a ~>> fun_list_a())

  bench("data provide/2", do: fun_list_a() |> provide(@list_a))
  bench("data supply/2", do: @list_a |> supply(fun_list_a()))

  bench("data lift/3", do: lift(@list_a, @list_a, &+/2))
  bench("data lift/4", do: lift(@list_a, @list_a, fn x, y, z -> x + y + z end))
  bench("data lift/5", do: lift(@list_a, @list_a, @list_a, fn w, x, y, z -> w + x + y + z end))

  bench("data over/3", do: over(&+/2, @list_a, @list_a))
  bench("data over/4", do: over(fn x, y, z -> x + y + z end, @list_a, @list_a))
  bench("data over/5", do: over(fn w, x, y, z -> w + x + y + z end, @list_a, @list_a, @list_a))

  bench("following/2", do: @list_a |> following(@list_a))
  bench("then/2", do: @list_a |> then(@list_a))

  # ----- #
  # Async #
  # ----- #

  bench("data async_convey/2", do: @list_a |> async_convey(fun_list_a()))
  bench("data async_ap/2", do: fun_list_a() |> async_ap(@list_a))

  bench("async_lift/3", do: async_lift(@list_a, @list_a, &+/2))
  bench("async_lift/4", do: async_lift(@list_a, @list_a, fn x, y, z -> x + y + z end))

  bench("async_lift/5",
    do: async_lift(@list_a, @list_a, @list_a, fn w, x, y, z -> w + x + y + z end)
  )

  bench("async_over/3", do: async_over(&+/2, @list_a, @list_a))
  bench("async_over/4", do: async_over(fn x, y, z -> x + y + z end, @list_a, @list_a))

  bench("async_over/5",
    do: async_over(fn w, x, y, z -> w + x + y + z end, @list_a, @list_a, @list_a)
  )

  bench("!!! convey/2", do: @list_a |> convey(slow_fun_list_a()))
  bench("!!! ap/2", do: slow_fun_list_a() |> ap(@list_a))

  bench "!!! lift/3" do
    lift(@list_a, @list_a, fn x, y ->
      Process.sleep(20)
      x + y
    end)
  end

  # So slow
  # bench "!!! lift/4" do
  #   lift(@list_a, @list_a, @list_a, fn(x, y, z) ->
  #     Process.sleep(20)
  #     x + y + z
  #   end)
  # end

  # also very slow, due to exponential complexity of multiple list dimensions
  # 50^4 = 6_250_000 items to process
  # bench "!!! lift/5" do
  #   lift(@list_a, @list_a, @list_a, @list_a, fn(w, x, y, z) ->
  #     Process.sleep(20)
  #     w + x + y + z
  #   end)
  # end

  bench "!!! over/3" do
    fn x, y ->
      Process.sleep(20)
      x + y
    end
    |> over(@list_a, @list_a)
  end

  # So slow
  # bench "!!! over/4" do
  #   fn(x, y, z) ->
  #     Process.sleep(20)
  #     x + y + z
  #   end
  #   |> over(@list_a, @list_a, @list_a)
  # end

  # So slow
  # bench "!!! over/5" do
  #   fn(w, x, y, z) ->
  #     Process.sleep(20)
  #     w + x + y + z
  #   end
  #   |> over(@list_a, @list_a, @list_a, @list_a)
  # end

  bench("!!! async_convey/2", do: @list_a |> async_convey(slow_fun_list_a()))
  bench("!!! async_ap/2", do: slow_fun_list_a() |> async_ap(@list_a))

  bench "!!! async_lift/3" do
    async_lift(@list_a, @list_a, fn x, y ->
      Process.sleep(20)
      x + y
    end)
  end

  bench "!!! async_lift/4" do
    async_lift(@list_a, @list_a, @list_a, fn x, y, z ->
      Process.sleep(20)
      x + y + z
    end)
  end

  bench "!!! async_lift/5" do
    async_lift(@list_a, @list_a, @list_a, @list_a, fn w, x, y, z ->
      Process.sleep(20)
      w + x + y + z
    end)
  end

  bench "!!! async_over/3" do
    fn x, y ->
      Process.sleep(20)
      x + y
    end
    |> async_over(@list_a, @list_a)
  end

  bench "!!! async_over/4" do
    fn x, y, z ->
      Process.sleep(20)
      x + y + z
    end
    |> async_over(@list_a, @list_a, @list_a)
  end

  bench "!!! async_over/5" do
    fn w, x, y, z ->
      Process.sleep(20)
      w + x + y + z
    end
    |> async_over(@list_a, @list_a, @list_a, @list_a)
  end

  # ==== #
  # Funs #
  # ==== #

  bench("funs convey/2", do: @list_b |> convey(fun_list_b()))
  bench("funs ap/2", do: fun_list_b() |> ap(@list_b))

  bench("funs <<~/2", do: fun_list_b() <<~ @list_b)
  bench("funs <<~/2", do: fun_list_b() <<~ @list_b)

  bench("funs ~>>/2", do: @list_b ~>> fun_list_b())
  bench("funs ~>>/2", do: @list_b ~>> fun_list_b())

  bench("funs provide/2", do: fun_list_b() |> provide(@list_b))
  bench("funs supply/2", do: @list_b |> supply(fun_list_b()))

  bench("following/2", do: @list_b |> following(@list_b))
  bench("then/2", do: @list_b |> then(@list_b))

  # ----- #
  # Async #
  # ----- #

  bench("funs async_convey/2", do: @list_b |> async_convey(fun_list_b()))
  bench("funs async_ap/2", do: fun_list_b() |> async_ap(@list_b))

  bench("funs async_lift/3", do: async_lift(@list_b, @list_b, &+/2))
  bench("funs async_lift/4", do: async_lift(@list_b, @list_b, fn x, y, z -> x + y + z end))

  bench("funs async_lift/5",
    do: async_lift(@list_b, @list_b, @list_b, fn w, x, y, z -> w + x + y + z end)
  )

  bench("funs async_over/3", do: async_over(&+/2, @list_b, @list_b))
  bench("funs async_over/4", do: async_over(fn x, y, z -> x + y + z end, @list_b, @list_b))

  bench("funs async_over/5",
    do: async_over(fn w, x, y, z -> w + x + y + z end, @list_b, @list_b, @list_b)
  )

  bench("!!! convey/2", do: @list_b |> convey(slow_fun_list_b()))
  bench("!!! ap/2", do: slow_fun_list_b() |> ap(@list_b))

  bench "!!! funs lift/3" do
    lift(@list_b, @list_b, fn x, y ->
      Process.sleep(20)
      x + y
    end)
  end

  # Just crazy slow
  # bench "!!! funs lift/4" do
  #   lift(@list_b, @list_b, @list_b, fn(x, y, z) ->
  #     Process.sleep(20)
  #     x + y + z
  #   end)
  # end

  # Just crazy slow
  # also very slow, due to exponential complexity of multiple list dimensions
  # (50 items * 20ms) ^ 4 lists = 1_000_000_000_000ms = 31 years :P
  # bench "!!! funs lift/5" do
  #   lift(@list_b, @list_b, @list_b, @list_b, fn(w, x, y, z) ->
  #     Process.sleep(20)
  #     w + x + y + z
  #   end)
  # end

  bench "!!! funs over/3" do
    fn x, y ->
      Process.sleep(20)
      x + y
    end
    |> over(@list_b, @list_b)
  end

  # So slow
  # bench "!!! funs over/4" do
  #   fn(x, y, z) ->
  #     Process.sleep(20)
  #     x + y + z
  #   end
  #   |> over(@list_b, @list_b, @list_b)
  # end

  # So slow
  # bench "!!! funs over/5" do
  #   fn(w, x, y, z) ->
  #     Process.sleep(20)
  #     w + x + y + z
  #   end
  #   |> over(@list_b, @list_b, @list_b, @list_b)
  # end

  bench("!!! funs async_convey/2", do: @list_b |> async_convey(slow_fun_list_b()))
  bench("!!! funs async_ap/2", do: slow_fun_list_b() |> async_ap(@list_b))

  bench "!!! funs async_lift/3" do
    async_lift(@list_b, @list_b, fn x, y ->
      Process.sleep(20)
      x + y
    end)
  end

  bench "!!! funs async_lift/4" do
    async_lift(@list_b, @list_b, @list_b, fn x, y, z ->
      Process.sleep(20)
      x + y + z
    end)
  end

  bench "!!! funs async_lift/5" do
    async_lift(@list_b, @list_b, @list_b, @list_b, fn w, x, y, z ->
      Process.sleep(20)
      w + x + y + z
    end)
  end

  bench "!!! funs async_over/3" do
    fn x, y ->
      Process.sleep(20)
      x + y
    end
    |> async_over(@list_b, @list_b)
  end

  bench "!!! funs async_over/4" do
    fn x, y, z ->
      Process.sleep(20)
      x + y + z
    end
    |> async_over(@list_b, @list_b, @list_b)
  end

  bench "!!! funs async_over/5" do
    fn w, x, y, z ->
      Process.sleep(20)
      w + x + y + z
    end
    |> async_over(@list_b, @list_b, @list_b, @list_b)
  end
end
