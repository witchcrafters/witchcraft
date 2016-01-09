defmodule WitchcraftTest do
  use ExUnit.Case

  doctest Witchcraft.Monoid, import: true
  doctest Witchcraft.Monoid.Operator, import: true
  doctest Witchcraft.Monoid.Property, import: true
end
