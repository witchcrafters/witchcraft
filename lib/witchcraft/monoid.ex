defprotocol Witchcraft.Monoid do
  @moduledoc """
  Monoids are a set, plus a binary combining operation (`op`) that
  returns another member of the set.

  # Properties
  1. Associativity
  For all `a`, `b`, and `c`: `a op (b op c) == (a op b) op c`

  2. Identity element
  - Unique element (`id`, sometimes called the 'zero' of the set)
  - Behaves as an identity with op

  # Examples
  ## Theory

  ```
  id = 0
  op = &(&1 + &2) # Integer addition
  op(34, id) == 34
  ```

  ```
  id = 1
  op = &(&1 * &2) # Integer multiplication
  op(42, id) == 42
  ```

  ## Concrete
  ```
  iex> defimpl Monoid, for: Integer do
  iex> def id(_), do: 0
  iex> def op(a, b), do: a + b
  iex> end
  iex> Monoid.op(1, 4) |> Monoid.op 2 |> Monoid.op 10
  17
  ```

  ## Counter-Example
  Integer division is not a monoid.
  Because you cannot divide by zero, the property does not hold for all values in the set.

  # Notes
  You can of course use abuse this protocol to define a fake "monoid" that behaves differently.
  For the protocol to operate as intended, you need to respect the above laws.
  """

  @doc """
  Check if the argument is a member of the monoid.
  Doubles as a definition of what belongs to the monoid.
  """
  @spec member?(any) :: boolean
  def member?(value)

  @doc "Get the idenity ('zero') element of the monoid by passing in any element of the set"
  @spec id(any) :: any
  def id(a)

  @doc "Combine two members of the monoid, and return another member"
  @spec op(any, any) :: any
  def op(a, b)

  # May want to have users impliment prop_id/2 et al,
  # to prove that the properties hold
end
