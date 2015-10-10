defmodule Witchcraft.Category.Extra do
  alias Witchcraft.Category, as: C

  def compose_left_to_right(a_to_b, b_to_c) do
    &(&1 |> C.compose(a_to_b) |> C.compose(b_to_c))
  end

  def compose_right_to_left(b_to_c, a_to_b) do
    &(&1 |> C.compose(a_to_b) |> C.compose(b_to_c))
  end
end
