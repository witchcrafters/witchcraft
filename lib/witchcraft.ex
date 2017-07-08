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

  ## `use Wicthcraft`

  There is a convenient `use` macro to import *all* functions in the library.

      use Witchcraft

  This recursively calls `use` on all children modules.

  Any options passed to `use` will be passed down to all dependencies.

      use Witchcraft, execpt: [right_fold: 2]

  If you would like to not override the functions and operators from `Kernel`,
  you can pass the special option `override_kernel: false`.

      use Witchcraft, override_kernel: false

  This same style of `use` is also available on all submodules, and follow
  the dependency chart (above).
  """

  defmacro __using__(opts \\ []) do
    quote do
      use Witchcraft.Arrow,       unquote(opts)
      use Witchcraft.Monoid,      unquote(opts)
      use Witchcraft.Bifunctor,   unquote(opts)
      use Witchcraft.Traversable, unquote(opts)
      use Witchcraft.Monad,       unquote(opts)
      use Witchcraft.Comonad,     unquote(opts)
    end
  end
end
