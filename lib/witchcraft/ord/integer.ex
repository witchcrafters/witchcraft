import TypeClass

definst Witchcraft.Ord, for: Integer do
  def compare(int_a, int_b) when int_a == int_b, do: :equal
  def compare(int_a, int_b) when int_a >  int_b, do: :greater
  def compare(int_a, int_b) when int_a <  int_b, do: :lesser
end
