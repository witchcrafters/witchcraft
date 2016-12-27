import TypeClass

defclass Witchcraft.Functor do
  extend Witchcraft.Setoid

  where do
    def lift(wrapped, fun)
  end

  defdelegate map(wrapped, fun), to: Proto, as: :lift

  properties do
    def identity(data) do
      wrapped = generate(data)
      fun = fn x -> data == x end

      Functor.lift(wrapped, fun) == wrapped
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
