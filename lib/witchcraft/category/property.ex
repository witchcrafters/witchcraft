defmodule Witchcraft.Category.Property do
  @moduledoc ~S"""
  Check samples of your category to confirm that your data adheres to the
  category properties. *All members* of your datatype should adhere to these rules.

  They are placed here as a quick way to spotcheck some of your values.
  """

  @doc ~S"""
  f . (g . h) == (f . g) . h == f . g . h
  """
  def associativity()

  @doc ~S"""
  if
    f : B -> C
    g : A -> B

  then there must be some `h` such that
    h : A -> C, h = f . g

  Proven with right and left identities:
    g . f == id_a
    f . g == id_b

  *Every* object in the category must have a identity.

  For every morphism `g : A -> B`:
  g . id_a == id_b . g == g
  """
  def left_identity
  def right_identity
end
