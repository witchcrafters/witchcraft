defmodule Witchcraft.Applicative.Property do
  @moduledoc ~S"""
  Check samples of your applicative functor to confirm that your data adheres to the
  applicative properties. *All members* of your datatype should adhere to these rules,
  *plus* implement `Witchcraft.Functor`.

  They are placed here as a quick way to spotcheck some of your values.
  """

  use Quark
  use Witchcraft.Applicative

  @doc ~S"""
  `seq`ing a lifted `id` to some lifted value `v` does not change `v`

  ## Examples

      iex> spotcheck_identity []
      true

  """
  @spec spotcheck_identity(any) :: boolean
  def spotcheck_identity(value), do: (value ~>> wrap(value, &id/1)) == value

  @doc ~S"""
  `seq` composes normally.

  ## Examples

      iex> spotcheck_composition([1, 2], [&(&1 * 2)], [&(&1 * 10)])
      true

  """
  @spec spotcheck_composition(any, any, any) :: boolean
  def spotcheck_composition(value, fun1, fun2) do
    wrap(value, &compose/2) <<~ fun1 <<~ fun2 <<~ value == fun1 <<~ (fun2 <<~ value)
  end

  @doc ~S"""
  `seq`ing a `wrap`ped function to a `wrap`ped value is the same as wrapping the
  result of the function on that value.

  ## Examples

      iex> spotcheck_homomorphism([], 1, &(&1 * 10))
      true

  """
  @spec spotcheck_homomorphism(any, any, fun) :: boolean
  def spotcheck_homomorphism(specemin, val, fun) do
    curried = curry(fun)
    wrap(specemin, val) ~>> wrap(specemin, curried) == wrap(specemin, curried.(val))
  end

  @doc ~S"""
  The order does not matter when `seq`ing to a `wrap`ped value
  and a `wrap`ped function.

  ## Examples

      iex> spotcheck_interchange(1, [&(&1 * 10)])
      true

  """
  @spec spotcheck_interchange(any, any) :: boolean
  def spotcheck_interchange(bare_val, wrapped_fun) do
    wrap(wrapped_fun, bare_val) ~>> wrapped_fun
      == wrapped_fun ~>> wrap(wrapped_fun, &(bare_val |> curry(&1).()))
  end

  @doc ~S"""

  Being an applicative _functor_, `seq` behaves as `lift` on `wrap`ped values

  ## Examples

      iex> spotcheck_functor([1,2,3], &(&1 * 10))
      true

  """
  @spec spotcheck_functor(any, fun) :: boolean
  def spotcheck_functor(wrapped_value, fun) do
    wrapped_value ~> fun == wrapped_value ~>> wrap(wrapped_value, fun)
  end
end
