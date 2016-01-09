defmodule WitchcraftTest do
  use ExUnit.Case

  doctest Witchcraft.Monoid, import: true
  doctest Witchcraft.Monoid.Operator, import: true
  doctest Witchcraft.Monoid.Property, import: true

  doctest Witchcraft.Functor, import: true
  doctest Witchcraft.Functor.Function, import: true
  doctest Witchcraft.Functor.Operator, import: true
  doctest Witchcraft.Functor.Property, import: true

  doctest Witchcraft.Applicative, import: true
  doctest Witchcraft.Applicative.Function, import: true
  doctest Witchcraft.Applicative.Operator, import: true
  # doctest Witchcraft.Applicative.Property, import: true
end
