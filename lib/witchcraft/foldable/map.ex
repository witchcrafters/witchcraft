import TypeClass

definst Witchcraft.Foldable, for: Map do
  def right_fold(map, seed, reducer) do
    map
    |> Map.values()
    |> Enum.reduce(seed, reducer)
  end
end
