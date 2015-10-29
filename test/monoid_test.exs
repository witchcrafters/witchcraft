defmodule MonoidTest do
  use ExUnit.Case

  import Witchcraft.Monoid
  import Witchcraft.Monoid.Functions
  import Witchcraft.Monoid.Properties

  doctest Witchcraft.Monoid
  doctest Witchcraft.Monoid.Functions
  doctest Witchcraft.Monoid.Properties

  # Happy case: Strings
  defimpl Witchcraft.Monoid, for: BitString do
    def identity(_), do: ""
    def op(a, b), do: a <> b
  end

  # Sad case: Malformed floats under division
  defimpl Witchcraft.Monoid, for: Float do
    def identity(_), do: -9.0
    def op(a, b), do: a / b
  end


  test "identity always returns the same value for that datatype" do
    assert identity("a") == identity("b")
  end

  test "identity combined with itself is the identity" do
    assert identity("") <|> identity("") == identity("")
  end

  test "left identity" do
    assert identity("welp") <|> "o hai" == "o hai"
  end

  test "right identity" do
    assert "o hai" <|> identity("welp") == "o hai"
  end

  test "spotcheck_identity is true for well formed monoids" do
    assert spotcheck_identity("well formed") == true
  end

  test "spotcheck_identity is false for malformed monoids" do
    assert spotcheck_identity(88.8) == false
  end

  test "spotcheck_associativity returns true when monoid is well formed" do
    assert spotcheck_associativity("a", "b", "c") == true
  end

  test "spotcheck_associativity returns false when monoid is poorly formed" do
    assert spotcheck_associativity(-9.1, 42.0, 88.8) == false
  end
end
