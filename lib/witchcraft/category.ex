defprotocol Witchcraft.Category do
  @moduledoc ~S"""
  """

  @fallback_to_any true

  @doc ~S"""
  Often a data constructor
  """
  @spec identity(any, any) :: any
  def identity(plain, specemin)

  @doc ~S"""
  """
  @spec compose(a, b) :: any
  def compose(a, b)
end

defimpl Witchcraft.Category, for: Any do
  defdelegate identity(a), to: Quark
  defdelegate compose(a, b), to: Quark
end

defimpl Witchcraft.Category, for: Witchcraft.Arrow.Kleisli do
  alias Witchcraft.Arrow.Kleisli, as: Kleisli

  import kleisli(a), from: Kleisli
  import a <~> b, from: Witchcraft.Monad.Operator

  def identity(a), do: a |> pure() |> kleisli()
  def compose(%Kleisli{binder: g}, %Kleisli{binder: h}), do: (g <~> h) |> kleisli()
end
