defmodule Witchcraft.Monad.Property do
  @moduledoc ~S"""
  Check samples of your monad to confirm that it adheres to the monad properties
  ("monad laws"). *All members* of your datatype should adhere to these rules.

  They are placed here as a quick way to spotcheck some of your values.
  """

  import Quark, only: [compose: 2, id: 1]
  import Quark.Curry, only: [curry: 1]

  import Witchcraft.Applicative, only: [seq: 2, wrap: 2]
  import Witchcraft.Applicative.Operator, only: [~>>: 2, <<~: 2]

  import Witchcraft.Functor.Operator, only: [~>: 2, <~: 2]

  defdelegate applicative(context, f, g, typecheck), to: Witchcraft.Applicative.Property

  @doc ~S"""
  Check all applicative properties

  ```elixir

  iex> appliative()
  true

  ```

  """
  @spec
  def monad(context, f, g, typecheck) do
    applicative(context, f, g, typecheck)
      and left_identity(value)
      and right_identity(value)
      and associativity(value)
  end

  def left_identity(a), do: a
  def right_identity(a), do: a
  def associativity(a), do: a
end
