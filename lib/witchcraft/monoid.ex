defmodule Monoid do
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

  identity = 0
  op = &(&1 + &2) # Integer addition
  append(34, identity) == 34

  identity = 1
  append = &(&1 * &2) # Integer multiplication
  append(42, identity) == 42

  ## Counter-Example
  Integer division is not a monoid.
  Because you cannot divide by zero, the property does not hold for all values in the set.
  """

  import Kernel, except: [<>: 2]

  defmacro __using__(_) do
    quote do
      import Kernel, except: [<>: 2]
      import unquote(__MODULE__)
    end
  end

  defdelegate identity(a), to: Witchcraft.Monoid.Protocol
  defdelegate append(a, b), to: Witchcraft.Monoid.Protocol

  defdelegate a <> b, to: Witchcraft.Monoid.Operator
end
