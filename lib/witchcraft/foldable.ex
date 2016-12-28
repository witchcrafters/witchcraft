import TypeClass

defclass Witchcraft.Foldable do
  @moduledoc ~S"""
  """

  where do
    @doc "reducer must be a binary function"
    def foldr(foldable, seed, reducer)
  end

  def fold() do
    # fold :: Monoid m => t m -> m Source #
    # Combine the elements of a structure using a monoid.
  end

  def foldl() do
  #   Left-associative fold of a structure.

  #   In the case of lists, foldl, when applied to a binary operator, a starting value (typically the left-identity of the operator), and a list, reduces the list using the binary operator, from left to right:

  #   foldl f z [x1, x2, ..., xn] == (...((z `f` x1) `f` x2) `f`...) `f` xn
  #   Note that to produce the outermost application of the operator the entire input list must be traversed. This means that foldl' will diverge if given an infinite list.

  # Also note that if you want an efficient left-fold, you probably want to use foldl' instead of foldl. The reason for this is that latter does not force the "inner" results (e.g. z f x1 in the above example) before applying them to the operator (e.g. to (f x2)). This results in a thunk chain O(n) elements long, which then must be evaluated from the outside-in.

  #   For a general Foldable structure this should be semantically identical to,

  #     foldl f z = foldl f z . toList
  end

  def foldr/2 do
    # foldr1 :: (a -> a -> a) -> t a -> a Source #

    # A variant of foldr that has no base case, and thus may only be applied to non-empty structures.

    # foldr1 f = foldr1 f . toList
  end

  def foldl/2 do
    # foldl1 :: (a -> a -> a) -> t a -> a Source #

    # A variant of foldl that has no base case, and thus may only be applied to non-empty structures.

    # foldl1 f = foldl1 f . toList
  end

  def to_list() do
    toList :: t a -> [a] Source #

    List of elements of a structure, from left to right.
  end

  def empty?() do
    # null :: t a -> Bool Source #

    # Test whether the structure is empty. The default implementation is optimized for structures that are similar to cons-lists, because there is no general way to do better.
  end

  def length do
    length :: t a -> Int Source #

    Returns the size/length of a finite structure as an Int. The default implementation is optimized for structures that are similar to cons-lists, because there is no general way to do better.
  end

  def elem do
    elem :: Eq a => a -> t a -> Bool infix 4 Source #

      Does the element occur in the structure?
  end

  def max do
    maximum :: forall a. Ord a => t a -> a Source #

    The largest element of a non-empty structure.
  end

  def min do
    maximum :: forall a. Ord a => t a -> a Source #

    The largest element of a non-empty structure.
  end

  def random do
    maximum :: forall a. Ord a => t a -> a Source #

    The largest element of a non-empty structure.
  end

  def sum do
    sum :: Num a => t a -> a Source #

    The sum function computes the sum of the numbers of a structure.
  end

  def product do
    product :: Num a => t a -> a Source #

    The product function computes the product of the numbers of a structure.
  end

  def fold_map() do
    # foldMap :: Monoid m => (a -> m) -> t a -> m Source #

    # Map each element of the structure to a monoid, and combine the results.
  end
# concat :: Foldable t => t [a] -> [a] Source #

# The concatenation of all the elements of a container of lists.

# concatMap :: Foldable t => (a -> [b]) -> t a -> [b] Source #

# Map a function over all the elements of a container and concatenate the resulting lists.

# and :: Foldable t => t Bool -> Bool Source #

# and returns the conjunction of a container of Bools. For the result to be True, the container must be finite; False, however, results from a False value finitely far from the left end.

# or :: Foldable t => t Bool -> Bool Source #

# or returns the disjunction of a container of Bools. For the result to be False, the container must be finite; True, however, results from a True value finitely far from the left end.

# any :: Foldable t => (a -> Bool) -> t a -> Bool Source #

# Determines whether any element of the structure satisfies the predicate.

# all :: Foldable t => (a -> Bool) -> t a -> Bool Source #

# Determines whether all elements of the structure satisfy the predicate.

# maximumBy :: Foldable t => (a -> a -> Ordering) -> t a -> a Source #

# The largest element of a non-empty structure with respect to the given comparison function.

# minimumBy :: Foldable t => (a -> a -> Ordering) -> t a -> a Source #

    # notElem :: (Foldable t, Eq a) => a -> t a -> Bool infix 4 Source #

    #   notElem is the negation of elem.

    #   find :: Foldable t => (a -> Bool) -> t a -> Maybe a Source #

    #     The find function takes a predicate and a structure and returns the leftmost element of the structure matching the predicate, or Nothing if there is no such element.

# The least element of a non-empty structure with respect to the given comparison function.
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
