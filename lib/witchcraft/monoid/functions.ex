defmodule Witchcraft.Monoid.Functions do
  alias Witchcraft.Monoid, as: Mon

  def a <|> b, do: Mon.op(a, b)
end
