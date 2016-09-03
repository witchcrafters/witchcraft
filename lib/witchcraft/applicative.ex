defmodule Witchcraft.Applicative do
  @moduledoc """
  Applicative functors provide a method of seqing a function contained in a
  data structure to a value of the same type. This allows you to seq and compose
  functions to values while avoiding repeated manual wrapping and unwrapping
  of those values.

  # Properties
  ## Identity
  `seq`ing a lifted `id` to some lifted value `v` does not change `v`

      seq(v, wrap(&id(&1))) == v

  ## Composition
  `seq` composes normally.

      seq((wrap &compose(&1,&2)), (seq(u,(seq(v, w))))) == seq(u,(seq(v, w)))

  ## Homomorphism
  `seq`ing a `wrap`ped function to a `wrap`ped value is the same as wrapping the
  result of the function on that value.

      seq(wrap x, wrap f) == wrap f(x))

  ## Interchange
  The order does not matter when `seq`ing to a `wrap`ped value
  and a `wrap`ped function.

      seq(wrap y, u) == seq(u, wrap &(lift(y, &1))

  ## Functor
  Being an applicative _functor_, `seq` behaves as `lift` on `wrap`ped values

      lift(x, f) == seq(x, (wrap f))

  # Notes
  Given that Elixir functons are right-associative, you can write clean looking,
  but much more ambiguous versions:

      wrap(y) |> seq(u) == seq(u, wrap(&lift(y, &1)))
      lift(x, f) == seq(x, wrap f)

  However, it is strongly recommended to include the parentheses for clarity.

  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      use Witchcraft.Functor
    end
  end

  defdelegate wrap(bare), to: Witchcraft.Applicative.Wrap

  defdelegate wrap(specemin, bare), to: Witchcraft.Applicative.Protocol
  defdelegate seq(any, fun),        to: Witchcraft.Applicative.Protocol

  defdelegate lift(value, fun),   to: Witchcraft.Applicative.Function
  defdelegate seq_first([a, b]),  to: Witchcraft.Applicative.Function
  defdelegate seq_second([a, b]), to: Witchcraft.Applicative.Function

  defdelegate data ~>> func, to: Witchcraft.Applicative.Operator
  defdelegate func <<~ data, to: Witchcraft.Applicative.Operator
end
