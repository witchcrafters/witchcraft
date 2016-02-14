defprotocol Witchcraft.Applicative do
  @moduledoc """
  Applicative functors provide a method of seqing a function contained in a
  data structure to a value of the same type. This allows you to seq and compose
  functions to values while avoiding repeated manual wrapping and unwrapping
  of those values.

  # Properties
  ## Identity
  `seq`ing a lifted `id` to some lifted value `v` does not change `v`

  `seq(v, wrap(&id(&1))) == v`

  ## Composition
  `seq` composes normally.

  `seq((wrap &compose(&1,&2)), (seq(u,(seq(v, w))))) == seq(u,(seq(v, w)))`

  ## Homomorphism
  `seq`ing a `wrap`ped function to a `wrap`ped value is the same as wrapping the
  result of the function on that value.

  `seq(wrap x, wrap f) == wrap f(x))`

  ## Interchange
  The order does not matter when `seq`ing to a `wrap`ped value
  and a `wrap`ped function.

  `seq(wrap y, u) == seq(u, wrap &(lift(y, &1))`

  ## Functor
  Being an applicative _functor_, `seq` behaves as `lift` on `wrap`ped values

  `lift(x, f) == seq(x, (wrap f))`

  # Notes
  Given that Elixir functons are right-associative, you can write clean looking,
  but much more ambiguous versions:

  `wrap(y) |> seq(u) == seq(u, wrap(&lift(y, &1)))`

  `lift(x, f) == seq(x, wrap f)`

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
  Sequentially seq lifted function(s) to lifted data.
  """
  @spec seq(any, (... -> any)) :: any
  def seq(wrapped_value, wrapped_function)
end

defimpl Witchcraft.Applicative, for: Any do
  @doc ~S"""
  By default, use the true identity functor (ie: don't wrap)
  """
  def wrap(_, bare_value), do: bare_value

  @doc ~S"""
  For un`wrap`ped values, treat `seq` as plain function application.
  """
  def seq(bare_value, bare_function), do: Quark.Curry.curry(bare_function).(bare_value)
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

  iex> seq([1,2,3], [&(&1 + 1), &(&1 * 10)])
  [2,3,4,10,20,30]

  iex> import Witchcraft.Functor, only: [lift: 2]
  iex> seq([9,10,11], lift([1,2,3], &(fn x -> x * &1 end)))
  [9,10,11,18,20,22,27,30,33]

  ```

  """
  def seq(_, []), do: []
  def seq(values, [fun|funs]) do
    Enum.map(values, curry(fun)) ++ Witchcraft.Applicative.seq(values, funs)
  end
end

# Algae.Id
# ========

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

  iex> seq(%Algae.Id{id: 42}, %Algae.Id{id: &(&1 + 1)})
  %Algae.Id{id: 43}

  iex> import Witchcraft.Functor, only: [lift: 2]
  iex> alias Algae.Id, as: Id
  iex> seq(%Id{id: 9}, lift(%Id{id: 2}, &(fn x -> x + &1 end)))
  %Algae.Id{id: 11}

  ```

  """
  def seq(%Id{id: value}, %Id{id: fun}), do: %Id{id: curry(fun).(value)}
end

# Algae.Maybe
# ===========

defimpl Witchcraft.Applicative, for: Algae.Maybe.Nothing do
  def wrap(%Algae.Maybe.Nothing{}, bare), do: %Algae.Maybe.Just{just: bare}

  def seq(%Algae.Maybe.Nothing{}, %Algae.Maybe.Nothing{}), do: %Algae.Maybe.Nothing{}
  def seq(%Algae.Maybe.Nothing{}, %Algae.Maybe.Just{just: _}), do: %Algae.Maybe.Nothing{}
end

defimpl Witchcraft.Applicative, for: Algae.Maybe.Just do
  import Quark.Curry, only: [curry: 1]

  def wrap(%Algae.Maybe.Just{just: _}, bare), do: %Algae.Maybe.Just{just: bare}

  def seq(%Algae.Maybe.Just{just: _}, %Algae.Maybe.Nothing{}), do: %Algae.Maybe.Nothing{}
  def seq(%Algae.Maybe.Just{just: value}, %Algae.Maybe.Just(just: fun)) do
    %Algae.Maybe.Just{just: curry(fun).(value)}
  end
end

# Algae.Either
# ============

defimpl Witchcraft.Applicative, for: Algae.Either.Left do
  def wrap(%Algae.Either.Left{left: _}, bare), do: %Algae.Either.Right{right: bare}

  def seq(%Algae.Either.Left{left: value}, %Algae.Either.Right{right: _}) do
    %Algae.Either.Left{left: value}
  end
end

defimpl Witchcraft.Applicative, for: Algae.Either.Right do
  import Quark.Curry, only: [curry: 1]

  def wrap(%Algae.Either.Right{right: _}, bare), do: %Algae.Either.Right{right: bare}

  def seq(%Algae.Either.Right{right: value}, %Algae.Either.Right{right: fun}) do
    %Algae.Either.Right{right: value ~> fun}
  end
end

# Algae.Free
# ==========
# Based on Ørjan Johansen's Free Applicative

defimpl Witchraft.Applicative, for: Algae.Free.Shallow do
  def wrap(%Algae.Free.Shallow{shallow: _}, bare), do: Algae.Free.shallow(bare)
  def seq(%Algae.Free.Shallow{shallow: shallow}, other), do: other ~> &(&1.(shallow))
end

defimpl Witchcraft.Applicative, for: Algae.Free.Deep do
  def wrap(%Algae.Free.Deep{deep: _, deeper: _}, bare), do: Algae.Free.shallow(bare)

  def seq(%Algae.Free.Deep{deep: deep, deeper: deeper}, %Algae.Free.Shallow{shallow: shallow}) do
    new_deeper = &Quark.compose/2 <~ %Algae.Free.Shallow{shallow: shallow} <<~ deeper
    %Algae.Free.deep(new_deeper, deep)
  end

  def seq(%Algae.Free.Deep{deep: deep1, deeper: deeper1}, %Algae.Free.Deep{deep: deep2, deeper: deeper2}) do
    new_deeper = &Quark.compose/2 <~ %Algae.Free.Deep{deep: deep2, deeper: deeper2} <<~ deeper1
    %Algae.Free.deep(new_deeper, deep1)
  end
end
