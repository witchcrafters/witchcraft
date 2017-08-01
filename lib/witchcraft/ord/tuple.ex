import TypeClass

definst Witchcraft.Ord, for: Tuple do
  # credo:disable-for-lines:6 Credo.Check.Refactor.PipeChainStart
  custom_generator(_) do
    fn -> TypeClass.Property.Generator.generate("") end
    |> Stream.repeatedly()
    |> Enum.take(Enum.random(0..100))
    |> List.to_tuple()
  end

  def compare(tuple_a, tuple_b) do
    Witchcraft.Ord.compare(Tuple.to_list(tuple_a), Tuple.to_list(tuple_b))
  end
end
