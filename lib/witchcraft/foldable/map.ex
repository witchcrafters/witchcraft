import TypeClass

definst Witchcraft.Foldable, for: Map do
  def right_fold(map, seed, reducer) do
    map
    |> Map.values()
    |> Witchcraft.Foldable.right_fold(seed, reducer)
  end
end
