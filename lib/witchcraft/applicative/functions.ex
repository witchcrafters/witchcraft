defmodule Witchcraft.Applicative.Functions do
  @moduledoc ~S"""
  Note that what would be `Applicative.lift` is `Functor.lift`.
  Given that yu have implimented Functor, this should not be an issue.
  """

  alias Witchcraft.Utils,       as: U
  alias Witchcraft.Functor,     as: F
  alias Witchcraft.Applicative, as: A

  def wrap(a), do: A.pure(a)

  @doc "Alias for `apply`"
  def left <~> right do
    Witchcraft.Applicative.apply(left, right)
  end

  @spec lift2(any, any, ({any, any} -> any)) :: any
  def lift2(wrapped1, wrapped2, binary_func) do
    wrapped2 |> A.apply(F.lift(wrapped1, binary_func))
  end

  @spec lift3(any, any, any, ({any, any, any} -> any)) :: any
  def lift3(wrapped1, wrapped2, wrapped3, trinary_func) do
    A.apply(wrapped3,
            A.apply(wrapped2,
                    F.lift(wrapped1, trinary_func)))
  end

  # Sequential application, discard first value
  @spec then(any, any) :: any
  def then(wrapped1, wrapped2) do
    lift2(wrapped1, wrapped2, &(U.const(U.id, &1)))
  end

  # Sequential application, discard second value
  @spec prior(any, any) :: any
  def prior(wrapped1, wrapped2) do
    lift2(wrapped1, wrapped2, U.const)
  end

  # traverse :: Applicative f => (a -> f b) -> t a -> f (t b)
  #   traverse f = sequenceA . fmap f

  # sequenceA :: Applicative f => t (f a) -> f (t a)
  #   sequenceA = traverse id
end
