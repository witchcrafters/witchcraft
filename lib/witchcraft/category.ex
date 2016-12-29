import TypeClass

defclass Witchcraft.Category do
  where do
    def identity(morphism)
    def compose(morphism_a, morphism_b)
  end

  def reverse_compose(b, a), do: compose(a, b)

  properties do
    # Same as monoid, but adjusted for categories

    def left_identity(data) do
      a = generate(data)
      Category.compose(Category.identity(a), a) == a
    end

    def right_identity(data) do
      a = generate(data)
      Category.compose(a, Category.identity(a)) == a
    end

    def associative(data) do
      a = generate(data)
      b = generate(data)
      c = generate(data)

      left  = a |> Category.compose(b) |> Category.compose(c)
      right = Category.compose(a, Category.compose(b, c))

      left == right
    end
  end
end

# definst Witchcraft.Category, for: Function do
#   def identity(fun), do: fun
#   def compose(f, g), do: Quark.compose(f, g)
# end
