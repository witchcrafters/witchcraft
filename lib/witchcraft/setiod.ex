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

    a.equals(b) === b.equals(a) (symmetry)
    def symmetry(data) do
      a = generate(data)
      b = generate(data)

      Setoid.equal?(a, b) == Setoid.equal?(b, a)
    end

    def transitivity(data) do
      a = generate(data)
      b = generate(data)
      c = generate(data)

      Setoid.equal?(a, b) && Setoid.equal?(b, c) && Setoid.equal?(a, c)
    end
  end
end
