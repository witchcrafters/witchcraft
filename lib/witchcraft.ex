defmodule Witchcraft do
  @moduledoc """
  Top level module

  ## Hierarchy

      Semigroupoid  Semigroup  Setoid   Foldable   Functor -----------┐
           ↓           ↓         ↓         ↓     ↙   ↓   ↘           |
        Category     Monoid     Ord    Traversable  Apply  Bifunctor  |
           ↓                                       ↙    ↘             ↓
         Arrow                            Applicative   Chain       Extend
                                                   ↘    ↙             ↓
                                                   Monad           Comonad

  ## `use Witchcraft`

  There is a convenient `use` macro to import *all* functions in the library.

      use Witchcraft

  This recursively calls `use` on all children modules.

  Any options passed to `use` will be passed down to all dependencies.

      use Witchcraft, except: [right_fold: 2]

  If you would like to not override the functions and operators from `Kernel`,
  you can pass the special option `override_kernel: false`.

      use Witchcraft, override_kernel: false

  This same style of `use` is also available on all submodules, and follow
  the dependency chart (above).
  """

  use Witchcraft.Internal,
    deps: [
      Witchcraft.Arrow,
      Witchcraft.Monoid,
      Witchcraft.Bifunctor,
      Witchcraft.Traversable,
      Witchcraft.Monad,
      Witchcraft.Comonad
    ]
end
