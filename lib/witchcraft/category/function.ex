defmodule Witchcraft.Category.Function do
  @moduledoc ~S"""
  Function helpers, derivatives and operators for `Witchcraft.Category`
  """

  @doc ~S"""
  Convenience function that composes `Category`s left-to-right.
  Sometimes called a "pipe" operation with implied subject.
  """
  def reverse_compose(morph_a, morph_b), do: Witchcraft.Category.compose(morph_b, morph_a)
end
