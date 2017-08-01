import TypeClass

definst Witchcraft.Ord, for: BitString do
  def compare(string_a, string_b) do
    Witchcraft.Ord.compare(String.to_charlist(string_a), String.to_charlist(string_b))
  end
end
