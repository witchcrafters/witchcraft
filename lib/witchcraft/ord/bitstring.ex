import TypeClass

definst Witchcraft.Ord, for: BitString do
  def compare(string_a, string_b) do
    cond do
      string_a == string_b -> :equal
      string_a < string_b -> :lesser
      true -> :greater
    end
  end
end
