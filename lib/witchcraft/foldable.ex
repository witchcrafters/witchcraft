import TypeClass

defclass Witchcraft.Foldable do
  @moduledoc ~S"""
  Data that can be folded over to change its structure by altering or combining elements

  ## Examples

      iex> sum = &right_fold(&1, 0, &+/2)
      ...> sum.([1, 2, 3])
      6
      ...> sum.([4, 5, 6])
      15

  ## Properties

  People are working on Foldable properties. This is one of the exceptions to
  there needing to conform to properties.
  The best closest property so far is abstract and strongly typed, so not
  easily expressible in Elixir.
  Ex. https://mail.haskell.org/pipermail/libraries/2015-February/024943.html

  """

  alias __MODULE__

  alias Witchcraft.Orderable
  alias Witchcraft.Orderable.Order
  alias Witchcraft.Semigroup

  import Kernel, except: [length: 1, max: 2, min: 2]

  require Foldable.EmptyError

  use Exceptional
  use Quark

  @type t :: any

  defmacro __using__(_) do
    quote do
      import Kernel, except: [length: 1, max: 2, min: 2]
      import unquote(__MODULE__)
    end
  end

  where do
    @doc ~S"""
    Right-associative fold over a structure to alter the structure and/or reduce
    it to a single summary value. The right-association makes it possible to
    cease computation on infinite streams of data.

    The reducer must be a binary function, with the second argument being the
    accumulated value thus far.

    ## Examples

        iex> sum = &right_fold(&1, 0, &+/2) end
        ...> sum.([1, 2, 3])
        6
        ...> sum.([4, 5, 6])
        15

    """
    @spec right_fold(Foldable.t, any, ((any, any) -> any)) :: any
    def right_fold(foldable, seed, reducer)
  end

  @doc ~S"""
  The same as `right_fold/3`, but uses the first element as the seed
  """
  @spec right_fold(Foldable.t, fun) :: any
  def right_fold(foldable, reducer) do
    case to_list(foldable) do
      []       -> []
      [a | as] -> right_fold(as, a, reducer)
    end
  end

  @spec fold_map(Foldable.t, fun) :: any
  def fold_map(foldable, fun) do
    import Witchcraft.Monoid
    foldable |> right_fold(empty(foldable), fn(x, acc) -> fun.(x) <> acc end)
  end

  @spec fold(Foldable.t) :: any
  def fold(foldable), do: fold_map(foldable, &Quark.id/1)

  #   Left-associative fold of a structure.

  #   In the case of lists, left_fold, when applied to a binary operator, a starting value (typically the left-identity of the operator), and a list, reduces the list using the binary operator, from left to right:

  #   left_fold f z [x1, x2, ..., xn] == (...((z `f` x1) `f` x2) `f`...) `f` xn
  #   Note that to produce the outermost application of the operator the entire input list must be traversed. This means that left_fold' will diverge if given an infinite list.

  # Also note that if you want an efficient left-fold, you probably want to use left_fold' instead of left_fold. The reason for this is that latter does not force the "inner" results (e.g. z f x1 in the above example) before applying them to the operator (e.g. to (f x2)). This results in a thunk chain O(n) elements long, which then must be evaluated from the outside-in.

  #   For a general Foldable structure this should be semantically identical to,

  #     left_fold f z = left_fold f z . toList
  # def left_fold(foldable, seed, reducer) do
  #   right_fold(foldable, &Quark.id/1, fn(seed_focus, acc) ->
  #     fn focus -> seed_focus.(reducer.(focus, acc)) end
  #   end).(seed)
  # end
  # left_fold f a bs = right_fold (\b g x -> g (f x b)) id bs a
  def left_fold(foldable, seed, reducer) do
    right_fold(foldable, &Quark.id/1, fn(x, g) -> fn (b) -> g.(reducer.(x, b)) end end).(seed)
  end

  # left_fold1 :: (a -> a -> a) -> t a -> a Source #
  # A variant of left_fold that has no base case, and thus may only be applied to non-empty structures.
  # left_fold1 f = left_fold1 f . toList
  def left_fold(foldable, reducer) do
    [x | xs] = to_list(foldable)
    left_fold(xs, x, reducer)
  end

  # toList :: t a -> [a] Source #
  # List of elements of a structure, from left to right.
  @spec to_list(Foldable.t) :: [any]
  def to_list(foldable), do: right_fold(foldable, [], fn(x, acc) -> [x | acc] end)

  @spec empty?(Foldable.t) :: boolean
  def empty?(foldable), do: right_fold(foldable, true, fn(_focus, _acc) -> false end)

  # Returns the size/length of a finite structure as an Int. The default implementation is optimized for structures that are similar to cons-lists, because there is no general way to do better.
  @spec length(Foldable.t) :: non_neg_integer
  def length(list) when is_list(list), do: Kernel.length(list)
  def length(foldable), do: right_fold(foldable, 0, fn(_, acc) -> 1 + acc end)

  defalias count(foldable), as: :length
  defalias size(foldable),  as: :length

  def elem(foldable, target) do
    right_fold(foldable, false, fn(focus, acc) -> acc or (focus == target) end)
  end

  @spec max(Foldable.t, by: ((any, any) -> Order.t)) :: Maybe.t
  def! max(foldable, by: comparator) do
    right_fold(foldable, fn(focus, acc) ->
      case comparator.(focus, acc) do
        %Order.Greater{} -> focus
        _ -> acc
      end
    end)
  end

  @spec max(Foldable.t) :: any
  def! max(foldable_comparable), do: max(foldable_comparable, by: &Orderable.compare/2)

  # The largest element of a non-empty structure.

  @spec min(Foldable.t, by: ((any, any) -> Order.t)) :: any | Maybe.t
  def! min(foldable, by: comparitor) do
    right_fold(foldable, fn(focus, acc) ->
      case comparitor.(focus, acc) do
        %Order.Greater{} -> focus
        _ -> acc
      end
    end)
  end

  def! min(foldable), do: min(foldable, by: &Orderable.compare/2)

  @spec random(Foldable.t) :: any | Foldable.EmptyError.t
  def! random(foldable) do
    foldable
    |> to_list
    |> safe(&Enum.random/1).()
    |> case do
         %Enum.EmptyError{} -> Foldable.EmptyError.new(foldable)
         value -> value
       end
  end

  @doc ~S"""
  Sum all numbers in a foldable

  ## Examples

      iex> sum [1, 2, 3]
      6

      iex> %BinaryTree{
      ...>   left:  4,
      ...>   right: %BinaryTree{
      ...>     left: 2,
      ...>     right: 10
      ...>   }
      ...> } |> sum
      16

  """
  @spec sum(Foldable.t) :: number
  def sum(foldable), do: right_fold(foldable, 0, &+/2)

  @doc ~S"""
  Product of all numbers in a foldable

  ## Examples

      iex> product [1, 2, 3]
      6

      iex> %BinaryTree{
      ...>   left:  4,
      ...>   right: %BinaryTree{
      ...>     left: 2,
      ...>     right: 10
      ...>   }
      ...> } |> product
      80

  """
  @spec product(Foldable.t) :: number
  def product(foldable), do: right_fold(foldable, 0, &*/2)

  @doc ~S"""
  Concatenate all lists in a foldable structure

  ## Examples

      iex> [[1, 2, 3], [4, 5, 6]]
      [1, 2, 3, 4, 5, 6]

      iex> %BinaryTree{
      ...>   left:  [1, 2, 3],
      ...>   right: %BinaryTree{
      ...>     left:  [4, 5],
      ...>     right: [6]
      ...>   }
      ...> }
      [1, 2, 3, 4, 5, 6]

  """
  @spec concat(Foldable.t) :: [any]
  def concat(contained_lists) do
    contained_lists
    |> right_fold([], Quark.flip(&Semigroup.append/2))
    |> Semigroup.concat
  end

  # Map a function over all the elements of a container and concatenate the resulting lists.
  @doc ~S"""
  Lift a function over a foldable structure generating lists of results,
  and then concatenate the resulting lists

  ## Examples

      iex> [1, 2, 3, 4, 5, 6]
      ...> |> concat_map(fn x -> [x, x] end)
      [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]

      iex> %BinaryTree{
      ...>   left:  1,
      ...>   right: %BinaryTree{
      ...>     left:  2,
      ...>     right: 3
      ...>   }
      ...> }
      ...> |> concat_map(fn x -> [x, x] end)
      [1, 1, 2, 2, 3, 3]

  """
  @spec concat_map(Foldable.t, (any -> [any])) :: [any]
  def concat_map(foldable, a_to_list_b) do
    foldable
    |> right_fold(fn(inner_focus, acc) -> a_to_list_b.(inner_focus) <> acc end)
    |> concat
  end

  @doc ~S"""
  Check if a foldable is full of only `true`s

  ## Examples

      iex> all? [true, true, false]
      false

      iex> %BinaryTree{
      ...>   left:  true,
      ...>   right: %BinaryTree{
      ...>     left:  true,
      ...>     right: false
      ...>   }
      ...> } |> all?
      false

  """
  @spec all?(Foldable.t) :: boolean
  def all?(foldable_bools), do: right_fold(foldable_bools, true, &and/2)

  @doc ~S"""
  The same as `all?/1`, but with a custom predicate matcher

  ## Examples

      iex> all?([1, 2, 3], &Integer.is_odd?/1)
      false

      iex> %BinaryTree{
      ...>   left:  1,
      ...>   right: %BinaryTree{
      ...>     left:  2,
      ...>     right: 3
      ...>   }
      ...> }
      ...> |> all?(&Integer.is_odd?/1)
      false

  """
  @spec all?(Foldable.t, (any -> boolean)) :: boolean
  def all?(foldable, predicate) do
    right_fold(foldable, true, fn(focus, acc) -> predicate.(focus) and acc end)
  end

  @doc ~S"""
  Check if a foldable contains any `true`s

  ## Examples

      iex> any? [true, true, false]
      true

      iex> %BinaryTree{
      ...>   left:  true,
      ...>   right: %BinaryTree{
      ...>     left:  true,
      ...>     right: false
      ...>   }
      ...> } |> any?
      true

  """
  @spec any?(Foldable.t) :: boolean
  def any?(foldable_bools), do: right_fold(foldable_bools, false, &or/2)

  @doc ~S"""
  The same as `all?/1`, but with a custom predicate matcher

  ## Examples

      iex> any?([1, 2, 3], &Integer.is_odd?/1)
      true

      iex> %BinaryTree{
      ...>   left:  1,
      ...>   right: %BinaryTree{
      ...>     left:  2,
      ...>     right: 3
      ...>   }
      ...> }
      ...> |> any(&Integer.is_odd?/1)
      true

  """
  @spec any?(Foldable.t, (any -> boolean)) :: boolean
  def any?(foldable, predicate) do
    right_fold(foldable, false, fn(focus, acc) -> predicate.(focus) or acc end)
  end

  properties do
  end
end

definst Witchcraft.Foldable, for: Tuple do
  def right_fold(tuple, seed, reducer), do: tuple |> Tuple.to_list |> right_fold(seed, reducer)
end

definst Witchcraft.Foldable, for: List do
  def right_fold(list, seed, reducer), do: List.foldr(list, seed, reducer)
end

definst Witchcraft.Foldable, for: Map do
  def right_fold(map, seed, reducer), do: Enum.reduce(map, seed, reducer)
end





    # WHEN WE HAVE MONAD
  # right_foldM :: (Foldable t, Monad m) => (a -> b -> m b) -> b -> t a -> m b Source #

  # Monadic fold over the elements of a structure, associating to the right, i.e. from right to left.

  # left_foldM :: (Foldable t, Monad m) => (b -> a -> m b) -> b -> t a -> m b Source #

  #   Monadic fold over the elements of a structure, associating to the left, i.e. from left to right.

# mapM_ :: (Foldable t, Monad m) => (a -> m b) -> t a -> m () Source #

# Map each element of a structure to a monadic action, evaluate these actions from left to right, and ignore the results. For a version that doesn't ignore the results see mapM.

# As of base 4.8.0.0, mapM_ is just traverse_, specialized to Monad.

# forM_ :: (Foldable t, Monad m) => t a -> (a -> m b) -> m () Source #

# forM_ is mapM_ with its arguments flipped. For a version that doesn't ignore the results see forM.

# As of base 4.8.0.0, forM_ is just for_, specialized to Monad.

# sequence_ :: (Foldable t, Monad m) => t (m a) -> m () Source #

# Evaluate each monadic action in the structure from left to right, and ignore the results. For a version that doesn't ignore the results see sequence.

# As of base 4.8.0.0, sequence_ is just sequenceA_, specialized to Monad.

# msum :: (Foldable t, MonadPlus m) => t (m a) -> m a Source #

# The sum of a collection of actions, generalizing concat. As of base 4.8.0.0, msum is just asum, specialized to MonadPlus.
# WHEN APPLICATIVE
# Applicative actions
#   traverse_ :: (Foldable t, Applicative f) => (a -> f b) -> t a -> f () Source #

#   Map each element of a structure to an action, evaluate these actions from left to right, and ignore the results. For a version that doesn't ignore the results see traverse.

#   for_ :: (Foldable t, Applicative f) => t a -> (a -> f b) -> f () Source #

#   for_ is traverse_ with its arguments flipped. For a version that doesn't ignore the results see for.

#   >>> for_ [1..4] print
#   1
#   2
#   3
#   4
#   sequenceA_ :: (Foldable t, Applicative f) => t (f a) -> f () Source #

#     Evaluate each action in the structure from left to right, and ignore the results. For a version that doesn't ignore the results see sequenceA.

#   asum :: (Foldable t, Alternative f) => t (f a) -> f a Source #

#   The sum of a collection of actions, generalizing concat.
