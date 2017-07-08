defmodule Witchcraft.Chain.AST do
  @moduledoc false

  @doc false
  def normalize({:__block__, _, inner}), do: inner
  def normalize(single) when is_list(single), do: [single]
  def normalize(plain), do: List.wrap(plain)
end
