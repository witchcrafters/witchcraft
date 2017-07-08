import TypeClass

definst Witchcraft.Foldable, for: Tuple do
  def right_fold(tuple, seed, reducer) do
    tuple
    |> Tuple.to_list()
    |> Witchcraft.Foldable.right_fold(seed, reducer)
  end
end
