import TypeClass

defclass Witchcraft.Foldable do
  @moduledoc ~S"""
  Data that can be folded over to change its structure by altering or combining elements

  ## Examples

      iex> sum = fn nums -> foldr(sums, 0, &+/2) end
      ...> sum.([1, 2, 3])
      6
      ...> sum.([4, 5, 6])
      15

  """

  alias Witchcraft.Orderable
  alias Witchcraft.Orderable.Order

  import Kernel, except: [length: 1, max: 2, min: 2]

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

        iex> sum = fn nums -> foldr(sums, 0, &+/2) end
        ...> sum.([1, 2, 3])
        6
        ...> sum.([4, 5, 6])
        15

    """
    @spec foldr(Foldable.t, any, ((any, any) -> any)) :: any
    def foldr(foldable, seed, reducer)
  end

  # foldr1 in Haskell
  @spec foldr(Foldable.t, fun) :: any
  def foldr(foldable, reducer) do
    foldable
    |> to_list
    |> foldr(reducer)
  end

  @spec fold_map(Foldable.t, fun) :: any
  def fold_map(foldable, fun) do
    import Witchcraft.Monoid
    foldable |> foldr(empty(foldable), fn(x, acc) -> fun.(x) <> acc end)
  end

  @spec fold(Foldable.t) :: any
  def fold(foldable), do: foldable |> fold_map(&Quark.id/1)

  #   Left-associative fold of a structure.

  #   In the case of lists, foldl, when applied to a binary operator, a starting value (typically the left-identity of the operator), and a list, reduces the list using the binary operator, from left to right:

  #   foldl f z [x1, x2, ..., xn] == (...((z `f` x1) `f` x2) `f`...) `f` xn
  #   Note that to produce the outermost application of the operator the entire input list must be traversed. This means that foldl' will diverge if given an infinite list.

  # Also note that if you want an efficient left-fold, you probably want to use foldl' instead of foldl. The reason for this is that latter does not force the "inner" results (e.g. z f x1 in the above example) before applying them to the operator (e.g. to (f x2)). This results in a thunk chain O(n) elements long, which then must be evaluated from the outside-in.

  #   For a general Foldable structure this should be semantically identical to,

  #     foldl f z = foldl f z . toList
  def foldl(foldable, seed, reducer) do
    foldr(foldable, &Quark.id/1, fn(seed_focus, acc) ->
      fn focus -> seed_focus.(reducer.(focus, acc)) end
    end)
  end

  # foldl1 :: (a -> a -> a) -> t a -> a Source #
  # A variant of foldl that has no base case, and thus may only be applied to non-empty structures.
  # foldl1 f = foldl1 f . toList
  def foldl(foldable, reducer) do
    foldable
    |> to_list
    |> foldl(reducer)
  end

  # toList :: t a -> [a] Source #
  # List of elements of a structure, from left to right.
  @spec to_list(Foldable.t) :: [any]
  def to_list(foldable), do: foldr(foldable, [], fn(x, acc) -> [x | acc] end)

  @spec empty?(Foldable.t) :: boolean
  def empty?(foldable), do: foldr(foldable, true, fn(_focus, _acc) -> false end)

  # Returns the size/length of a finite structure as an Int. The default implementation is optimized for structures that are similar to cons-lists, because there is no general way to do better.
  @spec length(Foldable.t) :: non_neg_integer
  def length(list) when is_list(list), do: Kernel.length(list)
  def length(foldable), do: foldr(foldable, 0, fn(_, acc) -> 1 + acc end)

  defalias count(foldable), as: :length
  defalias size(foldable),  as: :length

  def elem(foldable, target) do
    foldr(foldable, false, fn(focus, acc) -> acc or (focus == target) end)
  end

  @spec max(Foldable.t, by: ((any, any) -> Order.t)) :: Maybe.t
  def max(foldable, by: comparator) do
    foldr(foldable, fn(focus, acc) ->
      case comparator.(focus, acc) do
        %Order.Greater{} -> focus
        _ -> acc
      end
    end)
  end

  @spec max(Foldable.t) :: any
  def max(foldable_comparable), do: max(foldable_comparable, by: &Orderable.compare/2)

  def max!(foldable, by: comparator), do: foldable |> max(by: comparator) |> ensure!

  def max!(foldable), do: foldable |> max |> ensure!

  # The largest element of a non-empty structure.

  @spec min(Foldable.t, by: ((any, any) -> Order.t)) :: any | Maybe.t
  def min(foldable, by: comparitor) do
    foldr(foldable, fn(focus, acc) ->
      case comparitor.(focus, acc) do
        %Order.Greater{} -> focus
        _ -> acc
      end
    end)
  end

  def min(foldable), do: min(foldable, by: &Orderable.compare/2)

  def min!(foldable, by: comparator), do: foldable |> min(by: comparator) |> ensure!

  def min!(foldable), do: foldable |> min |> ensure!

  @spec random(Foldable.t) :: any | Foldable.EmptyError.t
  def random(foldable) do
    foldable
    |> to_list
    |> safe(Enum.random).()
    |> case do
         %Enum.EmptyError{} -> Foldable.EmptyError.new(foldable)
         value -> value
       end
  end

  @spec sum(Foldable.t) :: number
  def sum(foldable), do: foldr(foldable, 0, &+/2)

  @spec product(Foldable.t) :: number
  def product(foldable), do: foldr(foldable, 0, &*/2)

  # Map each element of the structure to a monoid, and combine the results.
  @spec fold_map(Foldable.t, fun) :: any
  def fold_map(foldable_monoid, fun) do
    import Witchcraft.Monoid
    foldr(foldable_monoid, empty(foldable_monoid), fn(focus, acc) ->
      fun.(focus) <> acc
    end)
  end

  # The concatenation of all the elements of a container of lists.
  # Must be a monoid
  def concat(contained_lists), do: foldr(contained_lists, &Witchcraft.Monoid.concat/2)

  # concatMap :: Foldable t => (a -> [b]) -> t a -> [b] Source #
  # Map a function over all the elements of a container and concatenate the resulting lists.
  def concat_map(foldable, a_to_list_b) do
    foldable
    |> foldr(fn(inner_focus, acc) -> a_to_list_b.(inner_focus) <> acc end)
    |> concat
  end

  # all? returns the conjunction of a container of Bools. For the result to be True, the container must be finite; False, however, results from a False value finitely far from the left end.
  @spec all?(Foldable.t) :: boolean
  def all?(foldable_bools), do: foldr(foldable_bools, true, &and/2)

  @spec all?(Foldable.t, (any -> boolean)) :: boolean
  def all?(foldable, predicate) do
    foldr(foldable, true, fn(focus, acc) -> predicate.(focus) and acc end)
  end

  # or :: Foldable t => t Bool -> Bool Source #
  # or returns the disjunction of a container of Bools. For the result to be False, the container must be finite; True, however, results from a True value finitely far from the left end.
  @spec any?(Foldable.t) :: boolean
  def any?(foldable_bools), do: foldr(foldable_bools, false, &or/2)

  @spec any?(Foldable.t, (any -> boolean)) :: boolean
  def any?(foldable, predicate) do
    foldr(foldable, false, fn(focus, acc) -> predicate.(focus) or acc end)
  end

  # People are working on Foldable properties
  # The best answer so far is abstract and strongly typed
  # Ex. https://mail.haskell.org/pipermail/libraries/2015-February/024943.html
  properties do
  end
end

definst Witchcraft.Foldable, for: List do
  def foldr(list, seed, reducer), do: Enum.reduce(list, seed, reducer)
end

definst Witchcraft.Foldable, for: Map do
  def foldr(map, seed, reducer), do: Enum.reduce(map, seed, reducer)
end





    # WHEN WE HAVE MONAD
  # foldrM :: (Foldable t, Monad m) => (a -> b -> m b) -> b -> t a -> m b Source #

  # Monadic fold over the elements of a structure, associating to the right, i.e. from right to left.

  # foldlM :: (Foldable t, Monad m) => (b -> a -> m b) -> b -> t a -> m b Source #

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
