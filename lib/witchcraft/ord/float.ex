import TypeClass

definst Witchcraft.Ord, for: Float do
  def compare(float_a, float_b) when float_a == float_b, do: :equal
  def compare(float_a, float_b) when float_a > float_b, do: :greater
  def compare(float_a, float_b) when float_a < float_b, do: :lesser
end
