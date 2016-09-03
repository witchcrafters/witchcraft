defprotocol Witchcraft.Functor.Protocol do

  @doc """
  Apply a function to every element in some collection, tree, or other structure.
  The collection will retain its structure (list, tree, and so on).
  """
  @spec lift(any, (any -> any)) :: any
  def lift(data, function)
end

defimpl Witchcraft.Functor, for: List do
  @doc ~S"""
      iex> lift([1,2,3], &(&1 + 1))
      [2,3,4]
  """
  def lift(data, func), do: Enum.map(data, func)
end

# Algae.Id
# ========

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
  import Quark, only: [<|>: 2]
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
