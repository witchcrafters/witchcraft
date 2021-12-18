defmodule Witchcraft.Semigroupoid.FunctionBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Semigroupoid

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  def f(x), do: "#{inspect(x)}/#{inspect(x)}"
  def g(y), do: "#{inspect(y)}-#{inspect(y)}-#{inspect(y)}"

  ##########
  # Simple #
  ##########

  bench("inline apply composed", do: (fn x -> x |> f() |> g() end).(1))
  bench("inline application", do: 1 |> f() |> g())

  bench("inline composition", do: fn x -> x |> f() |> g() end)

  bench "naive compose function" do
    (fn a, b ->
       fn c -> c |> a.() |> b.() end
     end).(&f/1, &g/1)
  end

  ################
  # Semigroupoid #
  ################

  bench("apply/2", do: apply(&f/1, [1]))
  bench("compose/2", do: compose(&f/1, &g/1))

  # --------- #
  # Operators #
  # --------- #

  bench("<|>/2", do: (&g/1) <|> (&f/1))
  bench("<~>/2", do: (&f/1) <~> (&g/1))

  bench("direct <|>/2", do: ((&g/1) <|> (&f/1)).(1))
  bench("direct <~>/2", do: 1 |> ((&f/1) <~> (&g/1)).())

  bench("apply <|>/2", do: apply((&g/1) <|> (&f/1), [1]))
  bench("apply <~>/2", do: apply((&f/1) <~> (&g/1), [1]))
end
