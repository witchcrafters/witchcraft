defprotocol Witchcraft.Category do
  @moduledoc ~S"""
  `Category` proves a way to generalize over the concept of computation.

  A category has two concepts: "objects" and "morphisms" connecting the objects.
  We are concerned here mostly with the morphisms, and it can construct a complete
  picture.

  `identity` and `compose` must form a monoid
  """

  @fallback_to_any true

  @doc ~S"""
  Often a data constructor, this is a morphism connecting an object to itself.

  """
  @spec identity(any) :: any
  def identity(a)

  @doc ~S"""
  Compose two morphisms
  """
  @spec compose(a, b) :: any
  def compose(a, b)
end

defimpl Witchcraft.Category, for: Any do
  defdelegate identity(a), to: Quark
  defdelegate compose(a, b), to: Quark
end

defimpl Witchcraft.Category, for: Algae.Kleisli do
  alias Algae.Kleisli, as: Kl

  import kleisli(a), from: Kl
  import a <~> b, from: Witchcraft.Monad.Operator

  def identity(a), do: a |> pure() |> kleisli()
  def compose(%Kl{binder: g}, %Kl{binder: h}), do: kleisli(g <~> h)
end
