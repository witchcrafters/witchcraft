defmodule Witchcraft do
  @moduledoc ~S"""
  Convenient `use` macro
  """

  defmacro __using__(_) do
    quote do
      use Witchcraft.Monoid

      use Witchcraft.Functor
      use Witchcraft.Applicative
      use Witchcraft.Monad

      use Witchcraft.Category
      use Witchcraft.Arrow
    end
  end
end
