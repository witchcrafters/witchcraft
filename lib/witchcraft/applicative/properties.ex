defmodule Witchcraft.Applicative.Properties do
  alias Witchcraft.Applicative, as: Apl

  def identity(id, elem) do
    Apl.apply(Apl.pure(id), elem) == elem
  end

  def homomorphism(elem, func) do
    Apl.apply(Apl.pure(func), Apl.pure(elem)) == Apl.pure((Apl.pure(elem)) |> func.())
  end

  # def interchange(u, y) do
    # Apl.apply(u, Apl.pure(y)) == Apl.apply(Apl.pure(&(y |> &1)), u)
  # end

  # def composition(u, v, w) do
  #   Apl.apply(u, Apl.apply(v, w)) == Apl.apply(Apl.apply(Apl.apply(Apl.pure(&(&2 |> &1), u), v), w))
  # end

  # def bonus_law(coll, func) do
  #   fmap(coll, func) == Apl.apply(coll, Apl.pure(func))
  # end
end
