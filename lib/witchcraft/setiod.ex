import TypeClass

defclass Witchcraft.Setoid do
  where do
    def equal?(a, b)
  end

  properties do
    def reflexivity(data) do
      a = generate(data)
      a |> Setoid.equal?(a)
    end

    def symmetry(data) do
      a = generate(data)
      b = generate(data)

      Setoid.equal?(a, b) == Setoid.equal?(b, a)
    end

    def transitivity(data) do
      a = b = c = generate(data)

      Setoid.equal?(a, b) and Setoid.equal?(b, c) and Setoid.equal?(a, c)
    end
  end
end

definst Witchcraft.Setoid, for: Integer do
  def equal?(a, b), do: a == b
end

definst Witchcraft.Setoid, for: BitString do
  def equal?(a, b), do: a == b
end

definst Witchcraft.Setoid, for: Tuple do
  def equal?(a, b), do: a == b
end

definst Witchcraft.Setoid, for: List do
  def equal?(a, b), do: a == b
end

definst Witchcraft.Setoid, for: Map do
  def equal?(a, b), do: a == b
end
