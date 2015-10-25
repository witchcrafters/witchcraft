defmodule MonoidTest do
  use ExUnit.Case

  import Witchcraft.Monoid
  import Witchcraft.Monoid.Functions
  import Witchcraft.Monoid.Properties

  doctest Witchcraft.Monoid
  doctest Witchcraft.Monoid.Functions
  doctest Witchcraft.Monoid.Properties

  defimpl Witchcraft.Monoid, for: Integer do
    def identity(_), do: 0
    def op(a, b), do: a + b
  end

  test "left identity" do
    assert (identity(9) <|> 42) == 42
  end
end
