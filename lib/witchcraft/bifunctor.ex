import TypeClass

defclass Witchcraft.Bifunctor do
  extend Witchcraft.Functor

  where do
    def bimap(functor, f, g)
  end

  def map_first(functor, f),  do: Bifunctor.bimap(functor, f, &Quark.id/1)
  def map_second(functor, g), do: Bifunctor.bimap(functor, &Quark.id/1, g)

  properties do
    def identity(data) do
      a = generate(data)

      left = Bifunctor.bimap(a, &Quark.id/1, &Quark.id/1)
      equal?(left, a)
    end

    def composition(data) do
      a = generate(data)

      f = &Witchcraft.Semigroup.append(&1, &1)
      g = &inspect/1

      h = &is_number/1
      i = &!/1

      left  = a |> Bifunctor.bimap(fn x -> f.(g.(x)) end, fn y -> h.(i.(y)) end)
      right = a |> Bifunctor.bimap(g, i) |> Bifunctor.bimap(f, h)

      equal?(left, right)
    end
  end
end

# definst Witchcraft.Bifunctor, for: Tuple do
#   def bimap({         a, b}, f, g), do: {         f.(a), g.(b)}
#   def bimap({x,       a, b}, f, g), do: {x,       f.(a), g.(b)}
#   def bimap({x, y,    a, b}, f, g), do: {x, y,    f.(a), g.(b)}
#   def bimap({x, y, z, a, b}, f, g), do: {x, y, z, f.(a), g.(b)}

#   def bimap(tuple, _, _) do
#     raise %Protocol.UndefinedError{
#       value: tuple,
#       description: "Witchcraft.Bifunctor not defined for #{inspect tuple}"
#     }
#   end
# end

# instance Bifunctor Either where
