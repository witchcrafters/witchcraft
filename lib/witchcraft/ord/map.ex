import TypeClass

definst Witchcraft.Ord, for: Map do
  # credo:disable-for-lines:12 Credo.Check.Refactor.PipeChainStart
  custom_generator(_) do
    values =
      fn -> TypeClass.Property.Generator.generate("") end
      |> Stream.repeatedly()
      |> Enum.take(Enum.random(0..100))

    fn -> TypeClass.Property.Generator.generate("") end
    |> Stream.repeatedly()
    |> Enum.take(Enum.random(0..100))
    |> Enum.zip(values)
    |> Enum.into(%{})
  end

  def compare(map_a, map_b) do
    Witchcraft.Ord.compare(Map.to_list(map_a), Map.to_list(map_b))
  end
end
