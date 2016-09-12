defmodule Witchcraft.Monad do
  @moduledoc ~S"""
  Because we are following the `Functor -> Applicative -> Monad` hierarchy,
  `return` is already defined as `pure`. `bind` can be defined in terms of `join`
  and `lift`, so we only need to define `join` for monads.
  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      use Witchcraft.Applicative
    end
  end

  defdelegate join(deep), to: Witchcraft.Monad.Protocol

  defdelegate bind(data, binder), to: Witchcraft.Monad.Function
  defdelegate compose(fun_one, fun_two), to: Witchcraft.Monad.Function

  defdelegate wrapped >>> fun, to: Witchcraft.Monad.Operator
  defdelegate fun <<< wrapped, to: Witchcraft.Monad.Operator
end
