defmodule Witchcraft.Category.Operator do
  def a <|> b, do: Witchcraft.Category.Protocol.compose(a, b)
end
