defmodule Witchcraft.Category.Extra do
  alias Witchcraft.Category, as: C

  def compose_left_to_right(a->b, b->c) do
    &(&1 |> C.compose(a->b) |> C.compose(b->c))
  end

  def compose_right_to_left(b->c, a->b) do
    &(&1 |> C.compose(a->b) |> C.compose(b->c))
  end
end
