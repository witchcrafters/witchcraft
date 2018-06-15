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

  def compare(list_a, list_b) do
    cond do
      list_a == list_b -> :equal
      list_a < list_b -> :lesser
      true -> :greater
    end
  end
end
