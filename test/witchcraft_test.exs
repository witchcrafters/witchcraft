defmodule WitchcraftTest do
  use ExUnit.Case

  # Monoid
  # ======
  doctest Witchcraft.Monoid, import: true

  doctest Witchcraft.Monoid.Integer, import: true
  doctest Witchcraft.Monoid.Float, import: true
  doctest Witchcraft.Monoid.BitString, import: true
  doctest Witchcraft.Monoid.List, import: true
  doctest Witchcraft.Monoid.Map, import: true

  doctest Witchcraft.Monoid.Operator, import: true
  doctest Witchcraft.Monoid.Property, import: true

  # Functor
  # =======
  doctest Witchcraft.Functor, import: true

  doctest Witchcraft.Functor.List, import: true
  doctest Witchcraft.Functor.Witchcraft.Id, import: true

  doctest Witchcraft.Functor.Function, import: true
  doctest Witchcraft.Functor.Operator, import: true
  doctest Witchcraft.Functor.Property, import: true

  # Applicative
  # ===========
  doctest Witchcraft.Applicative, import: true

  doctest Witchcraft.Applicative.List, import: true
  doctest Witchcraft.Applicative.Witchcraft.Id, import: true

  doctest Witchcraft.Applicative.Function, import: true
  doctest Witchcraft.Applicative.Operator, import: true
  doctest Witchcraft.Applicative.Property, import: true
end
