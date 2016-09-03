defmodule Witchcraft.Category.Property do
  @moduledoc ~S"""
  Check samples of your category to confirm that your data adheres to the
  category properties. *All members* of your datatype should adhere to these rules.

  They are placed here as a quick way to spotcheck some of your values.
  """

  @doc ~S"""
  f . (g . h) == (f . g) . h == f . g . h
  """
  def associativity(f, g, h) do
    #     -- Associativity: (f . g) . h = f . (g . h)
    #     (f . g) . h
    #     = \x -> (f . g) (h x)
    #     = \x -> f (g (h x))
    #     = \x -> f ((g . h) x)
    #     = \x -> (f . (g . h)) x
    #     = f . (g . h)
    base = (f <|> g) <|> h
    a = fn x -> (h(x)) |> (f <|> g) end
    b = fn x -> x |> h |> g |> f end
    c = fn x -> x |> (g <|> h) |> f end
    d = fn x -> x \> (f <|> (g <|> h))end
    e = f <|> (g <|> h)

    Enum.reduce([a, b, c, d, e], true, &(&2 && base == &1))
  end

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
  def left_identity(f) do
    # -- Left identity: id . f = f
    # id . f = \x -> id (f x)
    #        = \x -> f x
    #        = f

    a = fn x -> (x |> f) |> id end
    b = fn x -> x |> f end

    (identity <|> f == a)
    and (a == b)
    and (b == f)
  end

  def right_identity(f) do
    #   -- Right identity: f . id = f
    #   f . id
    #   = \x -> f (id x)
    #   = \x -> f x
    #   = f

    a = fn x -> (x |> id) |> f end
    b = fn x -> x |> f end

    (f <|> identity == a)
    and (a == b)
    and (b == f)
  end
end
