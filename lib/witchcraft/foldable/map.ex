import TypeClass

definst Witchcraft.Foldable, for: Map do
  def right_fold(map, seed, reducer), do: Enum.reduce(map, seed, reducer)
end
