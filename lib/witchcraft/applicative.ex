defprotocol Witchcraft.Applicative do
  require Witchcraft.ADT.Id
  @moduledoc """
  Applicative functors provide a method of applying a function contained in a
  data structure to a value of the same type. This allows you to apply and compose
  functions to values while avoiding repeated manual wrapping and unwrapping
  of those values.

  # Properties
  ## Identity
  `apply`ing a lifted `id` to some lifted value `v` does not change `v`

      iex> apply(v, wrap(&id(&1))) == v
      True

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

  @fallback_to_any true

  @doc ~S"""
  Lift a pure value into a type provided by some specemin (usually the zeroth
  or empty value of that type, but not nessesarily).
  """
  @spec wrap(any, any) :: any
  def wrap(specimen, bare)

  @doc ~S"""
  Sequentially apply lifted function(s) to lifted data.
  """
  @spec apply(any, (... -> any)) :: any
  def apply(wrapped_value, wrapped_function)
end

defimpl Witchcraft.Applicative, for: Any do
  @doc ~S"""
  By default, use the true identity functor (ie: don't wrap)
  """
  def wrap(_, bare), do: bare

  @doc ~S"""
  For un`wrap`ped values, treat `apply` as plain function application.
  """
  def apply(bare_value, bare_function), do: bare_function.(bare_value)
end
