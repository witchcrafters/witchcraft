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

  ```

  identity = 0
  op = &(&1 + &2) # Integer addition
  append(34, identity) == 34

  identity = 1
  append = &(&1 * &2) # Integer multiplication
  append(42, identity) == 42

  ```

  ## Counter-Example
  Integer division is not a monoid.
  Because you cannot divide by zero, the property does not hold for all values in the set.

  # Notes
  You can of course abuse this protocol to define a fake 'monoid' that behaves differently.
  For the protocol to operate as intended, you need to respect the above properties.
  """

  @doc "Get the identity ('zero') element of the monoid by passing in any element of the set"
  @spec identity(any) :: any
  def identity(a)

  @doc "Combine two members of the monoid, and return another member"
  @spec append(any, any) :: any
  def append(a, b)
end

defimpl Witchcraft.Monoid, for: Integer do
  @doc ~S"""

  ```elixir

  iex> identity(99) == identity(-9)
  true

  ```

  """
  def identity(_integer), do: 0

  @doc ~S"""

  ```elixir

  iex> 1 |> append(4) |> append(2) |> append(10)
  17

  ```

  """
  @spec append(integer, integer) :: integer
  def append(a, b), do: a + b
end

defimpl Witchcraft.Monoid, for: Float do
  @doc ~S"""

  ```elixir

  iex> identity(98.5) == identity(-8.5)
  true

  ```

  """
  def identity(_integer), do: 0.0

  @doc ~S"""

  ```elixir

  iex> 1.0 |> append(4.0) |> append(2.0) |> append(10.1)
  17.1

  ```

  """
  def append(a, b), do: a + b
end

defimpl Witchcraft.Monoid, for: BitString do
  @doc ~S"""

  ```elixir

  iex> append(identity("welp"), "o hai")
  "o hai"

  ```

  """
  def identity(_), do: ""

  @doc ~S"""

  ```elixir

  iex> append("o hai", identity("welp"))
  "o hai"

  iex> identity("") |> append(identity("")) == identity("")
  true

  ```

  """
  def append(a, b), do: a <> b
end

defimpl Witchcraft.Monoid, for: List do
  def identity(_list), do: []
  def append(as, bs), do: as ++ bs
end

defimpl Witchcraft.Monoid, for: Map do
  def identity(_map), do: %{}
  def append(ma, mb), do: Dict.merge(ma, mb)
end
