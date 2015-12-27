defmoule Witchraft.Applicative.Properties do
  @moduledoc ~S"""
  """

  import Witchcraft.Utility
  import Witchcraft.Applicative
  # import Witchcraft.Applicative.Functions

  @doc ~S"""
  `apply`ing a lifted `id` to some lifted value `v` does not change `v`
  """
  @spec spotcheck_applicative_identity()
  def spotcheck_applicative_identity(value) do
    value ~>> wrap &id(&1) == value
  end

  ## Composition
  `apply` composes normally.

      iex> apply((wrap &compose(&1,&2)),(apply(u,(apply(v, w))))) == apply(u,(apply(v, w)))
      True

  ## Homomorphism
  `apply`ing a `wrap`ped function to a `wrap`ped value is the same as wrapping the
  result of the function on that value.

      iex> apply(wrap x, wrap f) == wrap f(x))
      True

  ## Interchange
  The order does not matter when `apply`ing to a `wrap`ped value
  and a `wrap`ped function.

      iex> apply(wrap y, u) == apply(u, wrap &(lift(y, &1))
      True

  ## Functor
  Being an applicative _functor_, `apply` behaves as `lift` on `wrap`ped values

      iex> lift(x, f) == apply(x, (wrap f))
      True

  # Notes
  Given that Elixir functons are right-associative, you can write clean looking,
  but much more ambiguous versions:

      iex> wrap y |> apply u == u |> apply wrap &lift(y, &1)
      True

      iex> x |> lift f == x |> apply wrap f
      True

  However, it is strongly recommended to include the parentheses for clarity.
  """


end
