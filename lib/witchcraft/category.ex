defmodule Witchcraft.Category do

  defmacro __using__(_) do
    quote do
      import unuoqte(__MODULE__)
    end
  end

  defdelegate identity(a), to: Witchcraft.Category.Protocol
  defdelegate compose(a, b), to: Witchcraft.Category.Protocol

  defdelegate reverse_compose, to: Witchcraft.Category.Function

  defdelegate a <|> b, to: Witchcraft.Category.Operator
end
