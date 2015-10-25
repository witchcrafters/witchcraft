defmodule Witchcraft.Monoid.Functions do
  alias Witchcraft.Monoid, as: Mon

  @spec any <|> any :: any
  def a <|> b, do: Mon.op(a, b)
end
