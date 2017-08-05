import TypeClass

definst Witchcraft.Foldable, for: Tuple do
  def right_fold(tuple, seed, reducer) do
    index = tuple_size(tuple) - 1

    tuple
    |> elem(index)
    |> reducer.(seed)
  end
end
