import TypeClass

defclass Witchcraft.Semigroup do
  where do
    def concat(a, b)
  end

  defdelegate a <|> b, to: Proto, as: :concat

  properties do
    def associative(data) do
      a = generate(data)
      b = generate(data)
      c = generate(data)

      left  = a |> Semigroup.concat(b) |> Semigroup.concat(c)
      right = Semigroup.concat(a, Semigroup.concat(b, c))

      left == right
    end
  end
end

definst Witchcraft.Semigroup, for: Integer do
  def concat(a, b), do: a + b
end

definst Witchcraft.Semigroup, for: BitString do
  def concat(a, b), do: a <> b
end

definst Witchcraft.Semigroup, for: List do
  def concat(a, b), do: a ++ b
end

definst Witchcraft.Semigroup, for: Map do
  def concat(a, b), do: Map.merge(a, b)
end
