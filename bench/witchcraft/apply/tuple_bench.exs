defmodule Witchcraft.Apply.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Apply

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple 0..10 |> Enum.to_list() |> Enum.shuffle() |> List.to_tuple()

  def fun_tuple do
    @tuple |> replace(fn x -> "#{inspect x}-#{inspect x}" end)
  end

  def slow_fun_tuple do
    replace(@tuple, fn x ->
      Process.sleep(20)
      "#{inspect x}-#{inspect x}"
    end)
  end

  #########
  # Apply #
  #########

  # ==== #
  # Data #
  # ==== #

  bench "data convey/2", do: @tuple |> convey(fun_tuple())
  bench "data ap/2", do: fun_tuple() |> ap(@tuple)

  bench "data <<~/2", do: fun_tuple() <<~ @tuple
  bench "data <<~/2", do: fun_tuple() <<~ @tuple

  bench "data ~>>/2", do: @tuple ~>> fun_tuple()
  bench "data ~>>/2", do: @tuple ~>> fun_tuple()

  bench "data provide/2", do: fun_tuple() |> provide(@tuple)
  bench "data supply/2",  do: @tuple |> supply(fun_tuple())

  bench "data lift/3", do: lift(@tuple, @tuple, &+/2)
  bench "data lift/4", do: lift(@tuple, @tuple, fn(x, y, z) -> x + y + z end)
  bench "data lift/5", do: lift(@tuple, @tuple, @tuple, fn(w, x, y, z) -> w + x + y + z end)

  bench "data over/3", do: over(&+/2, @tuple, @tuple)
  bench "data over/4", do: over(fn(x, y, z) -> x + y + z end, @tuple, @tuple)
  bench "data over/5", do: over(fn(w, x, y, z) -> w + x + y + z end, @tuple, @tuple, @tuple)

  bench "following/2", do: @tuple |> following(@tuple)
  bench "then/2",      do: @tuple |> then(@tuple)

  # ----- #
  # Async #
  # ----- #

  bench "data async_convey/2", do: @tuple |> async_convey(fun_tuple())
  bench "data async_ap/2", do: fun_tuple() |> async_ap(@tuple)

  bench "async_lift/3", do: async_lift(@tuple, @tuple, &+/2)
  bench "async_lift/4", do: async_lift(@tuple, @tuple, fn(x, y, z) -> x + y + z end)
  bench "async_lift/5", do: async_lift(@tuple, @tuple, @tuple, fn(w, x, y, z) -> w + x + y + z end)

  bench "async_over/3", do: async_over(&+/2, @tuple, @tuple)
  bench "async_over/4", do: async_over(fn(x, y, z) -> x + y + z end, @tuple, @tuple)
  bench "async_over/5", do: async_over(fn(w, x, y, z) -> w + x + y + z end, @tuple, @tuple, @tuple)

  bench "!!! convey/2", do: @tuple |> convey(slow_fun_tuple())
  bench "!!! ap/2", do: slow_fun_tuple() |> ap(@tuple)

  bench "!!! lift/3" do
    lift(@tuple, @tuple, fn(x, y) ->
      Process.sleep(20)
      x + y
    end)
  end

  bench "!!! lift/4" do
    lift(@tuple, @tuple, @tuple, fn(x, y, z) ->
      Process.sleep(20)
      x + y + z
    end)
  end

  # also very slow, due to exponential complexity of multiple tuple dimensions
  # 50^4 = 6_250_000 items to process
  bench "!!! lift/5" do
    lift(@tuple, @tuple, @tuple, @tuple, fn(w, x, y, z) ->
      Process.sleep(20)
      w + x + y + z
    end)
  end

  bench "!!! over/3" do
    fn(x, y) ->
      Process.sleep(20)
      x + y
    end
    |> over(@tuple, @tuple)
  end

  bench "!!! over/4" do
    fn(x, y, z) ->
      Process.sleep(20)
      x + y + z
    end
    |> over(@tuple, @tuple, @tuple)
  end

  # So slow
  bench "!!! over/5" do
    fn(w, x, y, z) ->
      Process.sleep(20)
      w + x + y + z
    end
    |> over(@tuple, @tuple, @tuple, @tuple)
  end

  bench "!!! async_convey/2", do: @tuple |> async_convey(slow_fun_tuple())
  bench "!!! async_ap/2", do: slow_fun_tuple() |> async_ap(@tuple)

  bench "!!! async_lift/3" do
    async_lift(@tuple, @tuple, fn(x, y) ->
      Process.sleep(20)
      x + y
    end)
  end

  bench "!!! async_lift/4" do
    async_lift(@tuple, @tuple, @tuple, fn(x, y, z) ->
      Process.sleep(20)
      x + y + z
    end)
  end

  bench "!!! async_lift/5" do
    async_lift(@tuple, @tuple, @tuple, @tuple, fn(w, x, y, z) ->
      Process.sleep(20)
      w + x + y + z
    end)
  end

  bench "!!! async_over/3" do
    fn(x, y) ->
      Process.sleep(20)
      x + y
    end
    |> async_over(@tuple, @tuple)
  end

  bench "!!! async_over/4" do
    fn(x, y, z) ->
      Process.sleep(20)
      x + y + z
    end
    |> async_over(@tuple, @tuple, @tuple)
  end

  bench "!!! async_over/5" do
    fn(w, x, y, z) ->
      Process.sleep(20)
      w + x + y + z
    end
    |> async_over(@tuple, @tuple, @tuple, @tuple)
  end
end
