import TypeClass

defclass Witchcraft.Monoid do
  extend Witchcraft.Semigroup, alias: true

  where do
    def empty(sample)
  end

  defdelegate zero(sample), to: Proto, as: :empty

  properties do
    def left_identity(data) do
      a = generate(data)
      Semigroup.concat(Monoid.empty(a), a) == a
    end

    def right_identity(data) do
      a = generate(data)
      Semigroup.concat(a, Monoid.empty(a)) == a
    end
  end
end

definst Witchcraft.Monoid, for: Integer do
  def empty(_), do: 0
end

definst Witchcraft.Monoid, for: BitString do
  def empty(_), do: ""
end

definst Witchcraft.Monoid, for: List do
  def empty(_), do: []
end

definst Witchcraft.Monoid, for: Map do
  def empty(_), do: %{}
end
