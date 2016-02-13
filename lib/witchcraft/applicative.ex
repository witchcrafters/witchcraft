defprotocol Witchcraft.Applicative do
  @moduledoc """
  Applicative functors provide a method of applying a function contained in a
  data structure to a value of the same type. This allows you to apply and compose
  functions to values while avoiding repeated manual wrapping and unwrapping
  of those values.

  # Properties
  ## Identity
  `apply`ing a lifted `id` to some lifted value `v` does not change `v`

  `apply(v, wrap(&id(&1))) == v`

  ## Composition
  `apply` composes normally.

  `apply((wrap &compose(&1,&2)), (apply(u,(apply(v, w))))) == apply(u,(apply(v, w)))`

  ## Homomorphism
  `apply`ing a `wrap`ped function to a `wrap`ped value is the same as wrapping the
  result of the function on that value.

  `apply(wrap x, wrap f) == wrap f(x))`

  ## Interchange
  The order does not matter when `apply`ing to a `wrap`ped value
  and a `wrap`ped function.

  `apply(wrap y, u) == apply(u, wrap &(lift(y, &1))`

  ## Functor
  Being an applicative _functor_, `apply` behaves as `lift` on `wrap`ped values

  `lift(x, f) == apply(x, (wrap f))`

  # Notes
  Given that Elixir functons are right-associative, you can write clean looking,
  but much more ambiguous versions:

  `wrap(y) |> apply(u) == apply(u, wrap(&lift(y, &1)))`

  `lift(x, f) == apply(x, wrap f)`

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
  def wrap(_, bare_value), do: bare_value

  @doc ~S"""
  For un`wrap`ped values, treat `apply` as plain function application.
  """
  def apply(bare_value, bare_function), do: Quark.Curry.curry(bare_function).(bare_value)
end

defimpl Witchcraft.Applicative, for: List do
  import Quark.Curry, only: [curry: 1]

  @doc ~S"""

  ```elixir

  iex> wrap([], 0)
  [0]

  ```

  """
  def wrap(_, bare), do: [bare]

  @doc ~S"""

  ```elixir

  iex> import Kernel, except: [apply: 2]
  iex> apply([1,2,3], [&(&1 + 1), &(&1 * 10)])
  [2,3,4,10,20,30]

  iex> import Kernel, except: [apply: 2]
  iex> import Witchcraft.Functor, only: [lift: 2]
  iex> apply([9,10,11], lift([1,2,3], &(fn x -> x * &1 end)))
  [9,10,11,18,20,22,27,30,33]

  ```

  """
  def apply(_, []), do: []
  def apply(values, [fun|funs]) do
    Enum.map(values, curry(fun)) ++ Witchcraft.Applicative.apply(values, funs)
  end
end

defimpl Witchcraft.Applicative, for: Algae.Id do
  import Quark.Curry, only: [curry: 1]
  alias Algae.Id, as: Id

  @doc ~S"""

  ```elixir

  iex> %Algae.Id{} |> wrap(9)
  %Algae.Id{id: 9}

  ```

  """
  def wrap(_, bare), do: %Algae.Id{id: bare}

  @doc ~S"""
  ```elixir

  iex> import Kernel, except: [apply: 2]
  iex> apply(%Algae.Id{id: 42}, %Algae.Id{id: &(&1 + 1)})
  %Algae.Id{id: 43}

  iex> import Kernel, except: [apply: 2]
  iex> import Witchcraft.Functor, only: [lift: 2]
  iex> alias Algae.Id, as: Id
  iex> apply(%Id{id: 9}, lift(%Id{id: 2}, &(fn x -> x + &1 end)))
  %Algae.Id{id: 11}

  ```

  """
  def apply(%Id{id: value}, %Id{id: fun}), do: %Id{id: curry(fun).(value)}
end
