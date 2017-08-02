defmodule WitchcraftTest do
  use ExUnit.Case, async: true

  ################
  # Data Structs #
  ################

  doctest Witchcraft.Unit, import: true

  #################
  # Error Structs #
  #################

  # doctest Witchcraft.Foldable.EmptyError, import: true

  ################
  # Type Classes #
  ################

  doctest Witchcraft.Semigroupoid, import: true
  doctest Witchcraft.Category,     import: true
  doctest Witchcraft.Arrow,        import: true

  doctest Witchcraft.Setoid, import: true
  doctest Witchcraft.Ord,    import: true

  doctest Witchcraft.Semigroup, import: true
  doctest Witchcraft.Monoid,    import: true

  # doctest Witchcraft.Foldable,    import: true
  # doctest Witchcraft.Traversable, import: true

  doctest Witchcraft.Functor,   import: true
  # doctest Witchcraft.Bifunctor, import: true

  # doctest Witchcraft.Extend,  import: true
  # doctest Witchcraft.Comonad, import: true

  doctest Witchcraft.Apply,       import: true
  doctest Witchcraft.Applicative, import: true
  # doctest Witchcraft.Chain,       import: true
  # doctest Witchcraft.Monad,       import: true
end
