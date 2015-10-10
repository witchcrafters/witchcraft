defmodule Witchcraft.Arrow.Extra do
  alias Witchcraft.Category, as: C
  alias Witchcraft.Arrow,    as: A

  @spec product(A.arrow(any, any, any), A.arrow(any, any, any)) :: A.arrow(any, any, any)
  def product(f, g) do
    C.compose_left_to_right(A.first(f), A.second(g))
  end

  @spec fanout(A.arrow(any, any, any), A.arrow(any, any, any)) :: A.arrow(any, any, any)
  def fanout(f, g) do
    A.arr &({&1, &1})
    |> C.compose_left_to_right(product(f,g))
  end
end
