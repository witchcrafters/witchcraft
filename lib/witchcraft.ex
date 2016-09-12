defmodule Witchcraft do
  @moduledoc "Convenient top-level `use`"

  defmacro __using__(_) do
    quote do
      use Witchcraft.Monoid

      use Witchcraft.Functor
      use Witchcraft.Applicative
      use Witchcraft.Monad
    end
  end
end
