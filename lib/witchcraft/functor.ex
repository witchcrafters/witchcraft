import TypeClass

defclass Witchcraft.Functor do
  where do
    def lift(wrapped, fun)
  end

  defdelegate map(wrapped, fun), to: Proto, as: :lift

  properties do
    def identity(data) do
      wrapped = generate(data)
      Functor.lift(wrapped, &Quark.id/1) == wrapped
    end

    def composition(data) do
      wrapped = generate(data)

      f = fn x -> data == x end
      g = fn x -> data != x end

      x = wrapped |> Functor.lift(fn z -> z |> g.() |> f.() end)
      y = wrapped |> Functor.lift(g) |> Functor.lift(f)

      x == y
    end
  end
end

definst Witchcraft.Functor, for: List do
  def lift(list, fun), do: list |> Enum.map(fun)
end

definst Witchcraft.Functor, for: BitString do
  def lift(string, fun) do
    string
    |> String.to_charlist
    |> Witchcraft.Functor.lift(fun)
    |> String.from_list
  end
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
  def lift(map, fun), do: map |> Map.to_list |> Enum.into(%{})
end
