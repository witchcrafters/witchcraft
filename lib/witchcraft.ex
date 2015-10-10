defmodule Witchcraft do
  # @spec liftA
  def liftA(function, wrapped_element) do
    Witchcraft.Applicative.apply(wrapped_element, Witchcraft.Applicative.pure(function))
  end
end
