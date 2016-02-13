defmodule Witchcraft do
  @moduledoc ~S"""
  """

  # ======
  # Monoid
  # ======
  defdelegate identity(specemin), to: Witchcraft.Monoid

  defdelegate append(a, b), to: Witchcraft.Monoid
  defdelegate a <|> b, to: Witchcraft.Monoid.Operator

  # =======
  # Functor
  # =======
  defdelegate lift(data, function), to: Witchcraft.Functor
  defdelegate lift(function), to: Witchcraft.Functor.Function
  defdelegate lift(), to: Witchcraft.Functor.Function

  defdelegate data ~> func, to: Witchcraft.Functor.Operator
  defdelegate func <~ data, to: Witchcraft.Functor.Operator

  defdelegate replace(functor_data, const), to: Witchcraft.Functor.Function

  # ===========
  # Applicative
  # ===========
  defdelegate wrap(specemin, bare), to: Wicthcraft.Applicative

  defdelegate apply(wrapped_value, wrapped_function), to: Witchcraft.Applicative
  defdelegate value ~>> fun, to: Witchcraft.Applicative.Operator
  defdelegate fun <<~ value, to: Witchcraft.Applicative.Operator

  # Figure out the liftAs

  defdelegate seq_first([a,b]), to: Witchcraft.Applicative.Function
  defdelegate seq_second([a,b]), to: Witchcraft.Applicative.Function

  # =====
  # Monad
  # =====
  defdelegate join(deep), to: Witchcraft.Monad

  defdelegate bind(wrapped, fun), to: Witchcraft.Monad.Function
  defdelegate wrapped >>> fun, to: Witchcraft.Monad.Operator
  defdelegate fun <<< wrapped, to: Witchcraft.Monad.Operator
end
