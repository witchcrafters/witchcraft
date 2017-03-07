import TypeClass

defclass Witchcraft.Category do
  @moduledoc ~S"""
  In the context of Elixir: abstract over enforcing data types between morphisms
  """
  where do
    def identity(morphism)
    def compose(morphism_a, morphism_b)
  end

  def reverse_compose(b, a), do: compose(a, b)

  properties do
    # Same as monoid, but adjusted for categories

    def left_identity(data) do
      a = generate(data)
      ident = Category.compose(Category.identity(a), a)

      equal?(a, ident)
    end

    def right_identity(data) do
      a = generate(data)
      ident = Category.compose(a, Category.identity(a))

      equal?(a, ident)
    end

    def associative(data) do
      a = generate(data)
      b = generate(data)
      c = generate(data)

      left  = a |> Category.compose(b) |> Category.compose(c)
      right = Category.compose(a, Category.compose(b, c))

      equal?(left, right)
    end
  end
end
