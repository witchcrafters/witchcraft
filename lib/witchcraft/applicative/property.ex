defmodule Witchcraft.Applicative.Property do
  @moduledoc ~S"""
  Check samples of your applicative functor to confirm that your data adheres to the
  applicative properties. *All members* of your datatype should adhere to these rules,
  *plus* implement `Witchcraft.Functor`.

  They are placed here as a quick way to spotcheck some of your values.
  """

  import Kernel, except: [apply: 2]

  import Quark, only: [compose: 2, id: 1]
  import Quark.Curry, only: [curry: 1]

  import Witchcraft.Applicative, only: [apply: 2, wrap: 2]
  import Witchcraft.Applicative.Operator, only: [~>>: 2, <<~: 2]

  import Witchcraft.Functor.Operator, only: [~>: 2, <~: 2]

  @doc ~S"""
  `apply`ing a lifted `id` to some lifted value `v` does not change `v`

  ```elixir

  iex> spotcheck_identity []
  true

  iex> spotcheck_identity %Algae.Id{}
  true

  ```

  """
  @spec spotcheck_identity(any) :: boolean
  def spotcheck_identity(value), do: (value ~>> wrap(value, &id/1)) == value

  @doc ~S"""
  `apply` composes normally.

  iex> spotcheck_composition([1, 2], [&(&1 * 2)], [&(&1 * 10)])
  true

  """
  @spec spotcheck_composition(any, any, any) :: boolean
  def spotcheck_composition(value, fun1, fun2) do
    wrap(value, &compose/2) <<~ fun1 <<~ fun2 <<~ value == fun1 <<~ (fun2 <<~ value)
  end

  @doc ~S"""
  `apply`ing a `wrap`ped function to a `wrap`ped value is the same as wrapping the
  result of the function on that value.

  ```elixir

  iex> spotcheck_homomorphism([], 1, &(&1 * 10))
  true

  ```
  """
  @spec spotcheck_homomorphism(any, any, fun) :: boolean
  def spotcheck_homomorphism(specemin, val, fun) do
    curried = curry(fun)
    wrap(specemin, val) ~>> wrap(specemin, curried) == wrap(specemin, curried.(val))
  end

  @doc ~S"""
  The order does not matter when `apply`ing to a `wrap`ped value
  and a `wrap`ped function.

  ```elixir

  iex> spotcheck_interchange(1, [&(&1 * 10)])
  true

  ```

  """
  @spec spotcheck_interchange(any, any) :: boolean
  def spotcheck_interchange(bare_val, wrapped_fun) do
    wrap(wrapped_fun, bare_val) ~>> wrapped_fun
      == wrapped_fun ~>> wrap(wrapped_fun, &(bare_val |> curry(&1).()))
  end

  @doc ~S"""

  Being an applicative _functor_, `apply` behaves as `lift` on `wrap`ped values

  ```elixir

  iex> spotcheck_functor([1,2,3], &(&1 * 10))
  true

  iex> spotcheck_functor(%Algae.Id{id: 7}, &(&1 * 99))
  true

  ```

  """
  @spec spotcheck_functor(any, fun) :: boolean
  def spotcheck_functor(wrapped_value, fun) do
    wrapped_value ~> fun == wrapped_value ~>> wrap(wrapped_value, fun)
  end
end
