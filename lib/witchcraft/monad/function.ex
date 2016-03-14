defmodule Witchcraft.Monad.Function do
  import seq_second(a, b), from: Witchcraft.Applicative.Function

  @moduledoc ~S"""
  Function helpers, derivatives and operators for `Witchcraft.Monad`
  """

  import Witchcraft.Functor, only: [lift: 2]
  import Witchcraft.Monad, only: [join: 1]

  @doc ~S"""
  Operate on data wrapped inside of a monadic struct. Conceptually (though not actually)
  it unwraps the data, applies the function, and wraps the data up again.

  Note that when several `bind`s are chained, the later calls will have a strict data
  dependency on the earlier computations. This allows for parameter bindings from
  anonymous functions to be propagated through a series of logical steps (hence "bind").

  ```elixir

  iex> bind([1], fn x -> [x+1] end)
  [2]

  iex> bind(bind(bind([1], fn x -> 1 + x end), fn y -> 10 * y end), fn z -> 100 - z end)

  # More classic style allowing for variable sharing
  # (easier with the `>>>` operator in `Witchcraft.Monad.Operator`)
  iex> bind([1,2,3], fn x -> bind([x+1], fn y -> x * y end) end)
  [10,40,90]

  ```

  """
  @spec bind(any, fun) :: any
  def bind(data, binder), do: lift(data, binder) |> join

  @doc ~S"""
  Compose monadic `bind`ers
  """
  @spec compose((any -> any), (any -> any)) :: (any -> any)
  def compose(binder1, binder2) do
    &(Quark.curry(f).(&1) >>> g)
  end
end
