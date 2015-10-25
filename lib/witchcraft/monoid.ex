defprotocol Witchcraft.Monoid do
  @moduledoc ~S"""
  Monoids are a set of elements, and a binary combining operation (`op`) that
  returns another member of the set.

  # Properties
  ## Associativity
  1. Given a binary joining operation `•`,
  2. and all `a`, `b`, and `c` of the set,
  3. then: `a • (b • c) == (a • b) • c`

  ## Identity element
  - Unique element (`id`, sometimes called the 'zero' of the set)
  - Behaves as an identity with `op`

  # Examples
  ## Theory

  ```
  # Pseudocode
  identity = 0
  op = &(&1 + &2) # Integer addition
  op(34, id) == 34
  ```

  ```
  # Pseudocode
  identity = 1
  op = &(&1 * &2) # Integer multiplication
  op(42, id) == 42
  ```

  ## Concrete
  ```

  iex> alias Witchcraft.Monoid, as: Monoid
  iex> defimpl Monoid, for: Integer do
  iex>   def identity(_), do: 0
  iex>   def op(a, b), do: a + b
  iex> end
  iex> Monoid.op(1, 4) |> Monoid.op 2 |> Monoid.op 10
  17

  ```

  ## Counter-Example
  Integer division is not a monoid.
  Because you cannot divide by zero, the property does not hold for all values in the set.

  # Notes
  You can of course use abuse this protocol to define a fake 'monoid' that behaves differently.
  For the protocol to operate as intended, you need to respect the above properties.
  """

  @doc """
  Check if the argument is a member of the monoid.
  Doubles as a definition of what belongs to the monoid.
  """
  @spec member?(any) :: boolean
  def member?(value)

  @doc "Get the idenity ('zero') element of the monoid by passing in any element of the set"
  @spec identity(any) :: any
  def identity(a)

  @doc "Combine two members of the monoid, and return another member"
  @spec op(any, any) :: any
  def op(a, b)
end
