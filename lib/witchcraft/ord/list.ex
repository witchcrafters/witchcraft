import TypeClass

definst Witchcraft.Ord, for: List do
  custom_generator(_) do
    1
    |> Stream.unfold(fn acc ->
      next = TypeClass.Property.Generator.generate(1)
      {acc, next}
    end)
    |> Stream.drop(1)
    |> Stream.take(:rand.uniform(4))
    |> Enum.to_list()
  end

  def compare([], []), do: :equal
  def compare(_a, []), do: :greater
  def compare([], b) when is_list(b), do: :lesser

  def compare([head_a | tail_a], [head_b | tail_b]) do
    case Witchcraft.Ord.compare(head_a, head_b) do
      :equal -> Witchcraft.Ord.compare(tail_a, tail_b)
      order  -> order
    end
  end
end
