import TypeClass

defclass Witchcraft.Orderable do
  extend Witchcraft.Setoid
  extend Witchcraft.Monoid

  where do
    def compare(a, b)
  end

  def greater_than?(a, b) do
    case compare(a, b) do
      Order.Greater -> true
      Order.Lesser  -> false
      Order.Equal   -> false
    end
  end

  def lesser_than?(a, b) do
    case compare(a, b) do
      Order.Lesser  -> true
      Order.Greater -> false
      Order.Equal   -> false
    end
  end

  def equal?(a, b) do
    case compare(a, b) do
      Order.Equal   -> true
      Order.Lesser  -> false
      Order.Greater -> false
    end
  end

  properties do

  end
end

definst Witchcraft.Orderable, for: Integer do
  alias Witchcraft.Orderable.Order

  def compare(a, b) when is_number(b) do
    case a do
      ^b           -> Order.equal
      a when a > b -> Order.greater
      a when a < b -> Order.lesser
    end
  end
end

definst Witchcraft.Orderable, for: Float do
  alias Witchcraft.Orderable.Order

  def compare(a, b) when is_number(b) do
    case a do
      ^b           -> Order.equal
      a when a > b -> Order.greater
      a when a < b -> Order.lesser
    end
  end
end

definst Witchcraft.Orderable, for: List do
  alias Witchcraft.Orderable.Order

  def compare([], []), do: Order.equal
  def compare(a, []),  do: Order.greater
  def compare([], b) when is_list(b), do: Order.lesser
  def compare(a, b)  when is_list(b) do
    case compare(a, b) do
      %Order.Equal{} ->
        [_head_a, tail_a] = a
        [_head_b, tail_b] = b
        compare(tail_a, tail_b)

      order -> order
    end
  end
end

definst Witchcraft.Orderable, for: BitString do
  def compare(a, b) do
    a
    |> String.to_charlist
    |> compare(String.to_charlist(b))
  end
end
