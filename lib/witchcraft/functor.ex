defprotocol Witchcraft.Functor do
  @moduledoc ~S"""
  Functors provide a way to apply a function to value(s) a datatype
  (lists, trees, maybes, etc).

  All elements of the data being mapped over need to be consumable by
  the lifted function. The simplest way to handle this is to have only one
  type in the data/collection.

  The term `lift` is used rather than the more common `map`.
  First, this makes clear that the use is to lift functions into containers.
  Second, if you want mapping behaviour on collections, check out
  [`Enum.map`](http://elixir-lang.org/docs/v1.1/elixir/Enum.html#map/2).
  In fact, the default implimentation *is* `Enum.map`, so you can use this with the
  build-in datatypes.
  Third, the naming becomes more consistent with
  [`Applicative`](http://www.robotoverlord.io/witchcraft/Witchcraft.Applicative.Functions.html)'s
  `lift2`, `lift3`, and so on.

  # Properties
  ## Identity
  Mapping the identity function over the object returns the same object
  ex. `lift([1,2,3], id) == [1,2,3]`

  ## Distributive
  `lift(data, (f |> g)) == data |> lift(f) |> lift(g)`

  ## Associates all objects
  Mapping a function onto an object returns a value.
  ie: does not throw an error, returns a value of the target type (not of
  the wrong type, or the type `none`)

  # Notes:
  - The argument order convention is reversed from most other lanaguges
  - Most (if not all) implimentations of `lift` should be
    expressable in terms of [`Enum.reduce/3`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#reduce/3)
  - Falls back to [`Enum.map/2`](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#map/2)

  # Examples

      iex> [1,2,3] |> lift(&(&1 + 1))
      [2,3,4]

      iex> defimpl Witchcraft.Functor, for: Algae.Id do
      iex>   def lift(%Algae.Id{id: inner}, func), do: %Algae.Id{id: func.(inner)}
      iex> end
      iex> lift(%Algae.Id{id: 1}, &(&1 + 1))
      %Algae.Id{id: 2}

  """

  @doc """
  Apply a function to every element in some collection, tree, or other structure.
  The collection will retain its structure (list, tree, and so on).
  """
  @spec lift(any, (any -> any)) :: any
  def lift(data, function)
end

defimpl Witchcraft.Functor, for: List do
  @doc ~S"""

  ```elixir

  iex> lift([1,2,3], &(&1 + 1))
  [2,3,4]

  ```

  """
  def lift(data, func), do: Enum.map(data, func)
end

# Algae.Id
# ========

defimpl Witchcraft.Functor, for: Algae.Id do
  @doc ~S"""

  ```elixir

  iex> lift(%Algae.Id{id: 5}, &(&1 * 101))
  %Algae.Id{id: 505}

  ```

  """
  def lift(%Algae.Id{id: value}, fun), do: Algae.Id.id Quark.Curry.curry(fun).(value)
end

# Algae.Either
# ============

defimpl Witchcraft.Functor, for: Algae.Either.Left do
  def lift(%Algae.Either.Left{left: value}, fun) do
    Algae.Either.left Quark.Curry.curry(fun).(value)
  end
end

defimpl Witchcraft.Functor, for: Algae.Either.Right do
  def lift(%Algae.Either.Right{right: value}, fun) do
    Algae.Either.right Quark.Curry.curry(fun).(value)
  end
end

# Algae.Free
# ==========

defimpl Witchcraft.Functor, for: Algae.Free.Shallow do
  import Quark.Curry, only: [curry: 1]
  def lift(%Algae.Free.Shallow{shallow: shallow}, fun) do
    %Algae.Free.Shallow{shallow: curry(fun).(shallow)}
  end
end

defimpl Witchcraft.Functor, for: Algae.Free.Deep do
  import Quark.Curry, only: [curry: 1]
  import Witchcraft.Functor.Operator, only: [~>: 2]

  def lift(%Algae.Free.Deep{deep: deep, deeper: deeper}, fun) do
    %Algae.Free.Deep{deep: deep, deeper: deeper ~> &(fun <|> &1)}
  end
end


# Algae.Maybe
# ===========

defimpl Witchcraft.Functor, for: Algae.Maybe.Just do
  import Quark.Curry, only: [curry: 1]

  def lift(%Algae.Maybe.Just{just: value}, fun) do
    Algae.Maybe.just curry(fun).(value)
  end
end

defimpl Witchcraft.Functor, for: Algae.Maybe.Nothing do
  def lift(%Algae.Maybe.Nothing{}, _), do: Algae.Maybe.nothing
end

# Algae.Reader
# ============

defimpl Witchcraft.Functor, for: Algae.Reader do
  def lift(%Algae.Reader{reader: reader, env: env}, fun) do
    import Quark.Compose, only: [<|>: 2]
    %Algae.Reader{reader: fun <|> reader, env: env}
  end
end

# Algae.Tree
# ==========

defimpl Witchcraft.Functor, for: Algae.Tree.Leaf do
  def lift(%Algae.Tree.Leaf{leaf: value}, fun) do
    Quark.Curry.curry(fun).(value) |> Algae.Tree.leaf
  end
end

defimpl Witchcraft.Functor, for: Algae.Tree.Branch do
  def lift(%Algae.Tree.Branch{left: left, right: right}, fun) do
    %Algae.Tree.Branch{
      left: lift(left, Quark.Curry.curry(fun)),
      right: lift(right, Quark.Curry.curry(fun))
    }
  end
end

# Algae.Writer
# ============
#
# defimpl Witchcraft.Functor, for: Algae.Writer do
#   def lift(%Algae.Writer{writer: writer, env: env}, fun) do
#     import Quark.Compose, only: [<|>: 2]
#     %Algae.Writer{writer: fun <|> writer, env: env}
#   end
# end

# Algae.Tree.Rose
# ===============

defimpl Witchcraft.Functor, for: Algae.Tree.Rose do
  def lift(%Algae.Tree.Rose{rose: rose, tree: []}, fun) do
    %Algae.Tree.Rose{rose: Quark.Curry.curry(fun).(rose)}
  end

  def lift(%Algae.Tree.Rose{rose: rose, tree: tree}, fun) do
    %Algae.Tree.Rose{
      rose: Quark.Curry.curry(fun).(rose),
      tree: lift(tree, &(lift(&1, fun)))
    }
  end
end

# Algae.Tree.Search
# =================

defimpl Witchcraft.Functor, for: Algae.Tree.Search.Tip do
  def lift(%Algae.Tree.Search.Tip{}, _), do: Algae.Tree.Search.tip
end

defimpl Witchcraft.Functor, for: Algae.Tree.Search.Node do
  import Witchcraft.Functor.Operator, only: [<~: 2]

  def lift(%Algae.Tree.Search.Node{left: left, middle: middle, right: right}, fun) do
    %Algae.Tree.Search.Node{
      left: left <~ &lift(&1, fun),
      middle: middle <~ fun,
      right: right <~ &lift(&1, fun)
    }
  end
end
