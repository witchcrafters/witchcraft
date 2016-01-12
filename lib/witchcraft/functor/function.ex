defmodule Witchcraft.Functor.Function do
  @moduledoc ~S"""
  Functions that come directly from `lift`.
  """

  use Quark.Partial
  import Witchcraft.Functor, only: [lift: 2]

  @doc ~S"""
  Not strictly a curried version of `lift/2`. `lift/1` partially applies a function,
  to create a "lifted" version of that function.

  ```elixir

  iex> x10 = &lift(fn x -> x * 10 end).(&1)
  iex> [1,2,3] |> x10.()
  [10,20,30]

  iex> x10 = &lift(fn x -> x * 10 end).(&1)
  iex> %Witchcraft.Id{id: 13} |> x10.()
  %Witchcraft.Id{id: 130}

  ```

  """
  @spec lift((... -> any)) :: (any -> any)
  defpartial lift(fun), do: &lift(&1, fun)

  @doc ~S"""
  Replace all of the input's data nodes with some constant value

  ```elixir

  iex> [1,2,3] |> replace(42)
  [42, 42, 42]

  ```

  """
  @spec replace(any, any) :: any
  def replace(functor, const), do: lift(functor, &Quark.constant(const, &1))
end
