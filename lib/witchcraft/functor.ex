import TypeClass

defclass Witchcraft.Functor do
  @moduledoc ~S"""

  """

  where do
    @doc ~S"""

    """
    def lift(wrapped, fun)
  end

  defalias map(wrapped, fun), as: :lift
  defalias fmap(wrapped, fun), as: :lift

  defalias data ~> fun, as: :lift
  def fun <~ data, do: data ~> fun

  properties do
    def identity(data) do
      wrapped = generate(data)
      Functor.lift(wrapped, &Quark.id/1) == wrapped
    end

    def composition(data) do
      wrapped = generate(data)

      f = fn x -> inspect(wrapped == x) end
      g = fn x -> inspect(wrapped != x) end

      x = wrapped |> Functor.lift(fn x -> x |> g.() |> f.() end)
      y = wrapped |> Functor.lift(g) |> Functor.lift(f)

      x == y
    end
  end
end

definst Witchcraft.Functor, for: List do
  def lift(list, fun), do: Enum.map(list, fun)
end

definst Witchcraft.Functor, for: Tuple do
  def lift(tuple, fun) do
    tuple
    |> Tuple.to_list
    |> Witchcraft.Functor.lift(fun)
    |> List.to_tuple
  end
end

definst Witchcraft.Functor, for: Map do
  def lift(map, fun) do
    map
    |> Map.to_list
    |> Witchcraft.Functor.lift(fn {key, value} -> {key, fun.(value)} end)
    |> Enum.into(%{})
  end
end
