defmodule Witchcraft.Applicative.Property do
  @moduledoc ~S"""
  Check samples of your applicative functor to confirm that your data adheres to the
  applicative properties. *All members* of your datatype should adhere to these rules.

  They are placed here as a quick way to spotcheck some of your values.
  """

  import Quark, only: [compose: 2, id: 1]
  import Quark.Curry, only: [curry: 1]

  import Witchcraft.Applicative, only: [seq: 2, wrap: 2]
  import Witchcraft.Applicative.Operator, only: [~>>: 2, <<~: 2]

  import Witchcraft.Functor.Operator, only: [~>: 2, <~: 2]

  defdelegate functor(context, f, g, typecheck), to: Witchcraft.Functor.Property

  @doc ~S"""
  Check all applicative properties

  ```elixir

  iex> appliative()
  true

  ```

  """
  @spec
  def applicative(context, f, g, typecheck) do
    functor(context, f, g, typecheck)
      and identity(value)
      and composition(value, f, g)
      and homomorphism(specemin, val, fun)
      and interchange(bare_val, wrapped_fun)
      and simple_lift(wrapped_value, fun)
  end

  @doc ~S"""
  `seq`ing a lifted `id` to some lifted value `v` does not change `v`

  ```elixir

  iex> identity []
  true

  iex> identity %Algae.Id{}
  true

  ```

  """
  @spec identity(any) :: boolean
  def identity(value), do: (value ~>> wrap(value, &id/1)) == value

  @doc ~S"""
  `seq` composes normally.

  iex> composition([1, 2], [&(&1 * 2)], [&(&1 * 10)])
  true

  """
  @spec composition(any, any, any) :: boolean
  def composition(value, fun1, fun2) do
    wrap(value, &compose/2) <<~ fun1 <<~ fun2 <<~ value == fun1 <<~ (fun2 <<~ value)
  end

  @doc ~S"""
  `seq`ing a `wrap`ped function to a `wrap`ped value is the same as wrapping the
  result of the function on that value.

  ```elixir

  iex> homomorphism([], 1, &(&1 * 10))
  true

  ```
  """
  @spec homomorphism(any, any, fun) :: boolean
  def homomorphism(specemin, val, fun) do
    curried = curry(fun)
    wrap(specemin, val) ~>> wrap(specemin, curried) == wrap(specemin, curried.(val))
  end

  @doc ~S"""
  The order does not matter when `seq`ing to a `wrap`ped value
  and a `wrap`ped function.

  ```elixir

  iex> interchange(1, [&(&1 * 10)])
  true

  ```

  """
  @spec interchange(any, any) :: boolean
  def interchange(bare_val, wrapped_fun) do
    wrap(wrapped_fun, bare_val) ~>> wrapped_fun
      == wrapped_fun ~>> wrap(wrapped_fun, &(bare_val |> curry(&1).()))
  end

  @doc ~S"""

  Being an applicative _functor_, `seq` behaves as `lift` on `wrap`ped values

  ```elixir

  iex> simple_lift([1,2,3], &(&1 * 10))
  true

  iex> simple_lift(%Algae.Id{id: 7}, &(&1 * 99))
  true

  ```

  """
  @spec simple_lift(any, fun) :: boolean
  def simple_lift(wrapped_value, fun) do
    wrapped_value ~> fun == wrapped_value ~>> wrap(wrapped_value, fun)
  end
end
