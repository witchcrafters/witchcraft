![](https://github.com/expede/witchcraft/raw/main/brand/Wordmark/PNG/WC-wordmark-lrg@2x.png)

`Witchcraft` is a library providing common algebraic and categorical abstractions to Elixir.
Monoids, functors, monads, arrows, categories, and other dark magic right at your fingertips.

[![Build Status](https://travis-ci.org/expede/witchcraft.svg?branch=master)](https://travis-ci.org/expede/witchcraft)
[![Inline docs](http://inch-ci.org/github/expede/witchcraft.svg?branch=master)](http://inch-ci.org/github/expede/witchcraft)
[![API Docs](https://img.shields.io/badge/api-docs-MediumPurple.svg?style=flat)](http://hexdocs.pm/witchcraft/)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/expede/witchcraft/blob/master/LICENSE)

[![](https://opencollective.com/witchcraft/tiers/backer.svg?avatarHeight=50)](https://opencollective.com/witchcraft/contribute/tier/8074-backer)

[![](https://opencollective.com/witchcraft/tiers/sponsor.svg?avatarHeight=50)](https://opencollective.com/witchcraft/contribute/tier/8075-sponsor)

# README

## Table of Contents

* [Quick Start](#quick-start)
* [Library Family](#library-family)
* [Values](#values)
* [Type Class Hierarchy](#type-class-hierarchy)
* [Writing Class Instances](#writing-class-instances)
* [Operators](#operators)
* [Haskell Translation Table](#haskell-translation-table)
* [Prior Art and Further Reading](#prior-art-and-further-reading)
* [Credits](#credits)

## Quick Start

```elixir
def deps do
  [{:witchcraft, "~> 1.0"}]
end

# ...

use Witchcraft
```

## Library Family

```
Quark    TypeClass
    ↘    ↙
   Witchcraft
       ↓
     Algae
```

| Name                                              | Description                                                   |
|--------------------------------------------------:|---------------------------------------------------------------|
| [`Quark`](https://hex.pm/packages/quark)          | Standard combinators (`id`, `compose`, &c)                    |
| [`TypeClass`](https://hex.pm/packages/type_class) | Used internally to generate type classes                      |
| [`Algae`](https://hex.pm/packages/algae)          | Algebraic data types that implement `Witchcraft` type classes |

## Values

### Beginner Friendliness

You shouldn't have to learn another language just to understand powerful abstractions!
By enabling people to use a language that they already know, and is already in the
same ballpark in terms of values (emphasis on immutability, &c), we can teach and
learn faster.

As much as possible, keep things friendly and well explained.
Concrete examples are available via doctests.

### Consistency & Ethos

Elixir does a lot of things differently from certain other functional languages.
The idea of a data "subject" being piped though functions is conceptually different from
pure composition of functions that are later applied. `Witchcraft` honours the
Elixir/Elm/OCaml way, and operators point in the direction that data travels.

Some functions in the Elixir standard library have been expanded to work with more
types while keeping the basic idea the same. For example, `<>` has been expanded
to work on any [monoid](https://hexdocs.pm/witchcraft/Witchcraft.Monoid.html)
(such as integers, lists, bitstrings, and so on).

All operators have named equivalents, and auto-currying variants of higher order functions
are left at separate names so you can performance tune as needed (currying is helpful for
more abstract code). With a few exceptions (we're looking at you, `Applicative`),
pipe-ordering is maintained.

### Pragmatism
Convincing a company to use a language like [Haskell](https://www.haskell.org)
or [PureScript](http://www.purescript.org) can be challenging. Elixir is gaining
a huge amount of interest. Many people have been able to introduce these concepts
into companies using Scala, so we should be able to do the same here.

All functions are compatible with regular Elixir code, and no types are enforced aside
from what is used in protocol dispatch. Any struct can be made into a Witchcraft
class instance (given that it conforms to the properties).

## Type Class Hierarchy

```
Semigroupoid  Semigroup  Setoid   Foldable   Functor -----------┐
     ↓           ↓         ↓         ↓      ↙   ↓   ↘           |
  Category     Monoid     Ord    Traversable  Apply  Bifunctor  |
     ↓                                       ↙    ↘             ↓
   Arrow                            Applicative   Chain       Extend
                                             ↘    ↙             ↓
                                              Monad           Comonad
```

Having a clean slate, we have been able to use a clean set of type classes. This is largely
taken from the [Fantasy Land Specification](https://github.com/fantasyland/fantasy-land)
and Edward Kmett's [`semigroupoids`](https://hackage.haskell.org/package/semigroupoids) package.

As usual, all `Applicative`s are `Functor`s, and all `Monad`s are `Applicative`s.
This grants us the ability to reuse functions in their child classes.
For example, `of` can be used for both `pure` and `return`, `lift/*` can handle
both `liftA*` and `liftM*`, and so on.

### Import Chains

It is very common to want to import a class and all of its dependencies.
You can do this with `use`. For example, you can import the entire library with:

```elixir
use Witchcraft
```

Or import a module plus all others that it depends on:

```elixir
use Witchcraft.Applicative
```

Any options that you pass to `use` will be propagated all the way down the chain:

```elixir
use Witchcraft.Applicative, except: [~>: 2]
```

Some modules override `Kernel` operators and functions. While this is generally safe,
if you would like to skip all overrides, pass `override_kernel: false` as an option:

```elixir
use Witchcraft.Applicative, override_kernel: false

# Or even

use Witchcraft, override_kernel: false
```

## Writing Class Instances

How to make your custom struct compatible with `Witchcraft`:

1. Read the [`TypeClass` README](https://hexdocs.pm/type_class/readme.html)
2. Implement the [`TypeClass` data generator protocol](https://hexdocs.pm/type_class/TypeClass.Property.Generator.html#content) for your struct
3. Use [`definst`](https://hexdocs.pm/type_class/TypeClass.html#definst/3) ("define instance") instead of `defimpl`:

```elixir
definst Witchcraft.Functor, for: Algae.Id do
  def map(%{id: data}, fun), do: %Algae.Id{id: fun.(data)}
end
```

All classes have properties that your instance must conform to at compile time.
`mix` will alert you to any failing properties by name, and will refuse to compile
without them. Sometimes it is not possible to write an instance that will pass the check,
and you can either write a [custom generator](https://hexdocs.pm/type_class/readme.html#custom_generator-1)
for that instance, or [force](https://hexdocs.pm/type_class/readme.html#force_type_instance-true)
the instance. If you must resort to forcing the instance, please write a test
of the property for some specific case to be reasonably sure that it will be compatible
with the rest of the library.

More reference instances are available in [`Algae`](https://github.com/expede/algae).

## Operators

| Family       | Function         | Operator |
|-------------:|:-----------------|:---------|
| Setoid       | `equivalent?`    | `==`     |
|              | `nonequivalent?` | `!=`     |
| Ord          | `greater_than?`  | `>`      |
|              | `lesser_than?`   | `<`      |
| Semigroup    | `append`         | `<>`     |
| Functor      | `lift`           | `~>`     |
|              | `convey`         | `~>>`    |
|              | `chain`          | `>>>`    |
|              | `over`           | `<~`     |
|              | `ap`             | `<<~`    |
|              | `reverse_chain`  | `<<<`    |
| Semigroupoid | `compose`        | `<\|>`   |
|              | `pipe_compose`   | `<~>`    |
| Arrow        | `product`        | `^^^`    |
|              | `fanout`         | `&&&`    |


## Haskell Translation Table

| Haskell Prelude | Witchcraft         |
|----------------:|:-------------------|
| `flip ($)`      | `\|>/2` (`Kernel`) |
| `.`             | `<\|>/2`           |
| `<<<`           | `<\|>/2`           |
| `>>>`           | `<~>/2`            |
| `<>`            | `<>/2`             |
| `<$>`           | `<~/2`             |
| `flip (<$>)`    | `~>/2`             |
| `fmap`          | `lift/2`           |
| `liftA`         | `lift/2`           |
| `liftA2`        | `lift/3`           |
| `liftA3`        | `lift/4`           |
| `liftM`         | `lift/2`           |
| `liftM2`        | `lift/3`           |
| `liftM3`        | `lift/4`           |
| `ap`            | `ap/2`             |
| `<*>`           | `<<~/2`            |
| `<**>`          | `~>>/2`            |
| `*>`            | `then/2`           |
| `<*`            | `following/2`      |
| `pure`          | `of/2`             |
| `return`        | `of/2`             |
| `>>`            | `then/2`           |
| `>>=`           | `>>>/2`            |
| `=<<`           | `<<</2`            |
| `***`           | `^^^/2`            |
| `&&&`           | `&&&/2`            |

## Prior Art and Further Reading

This library draws heavy inspiration from mathematics, other languages,
and other Elixir libraries. We would be ashamed not to mention them here.
There is much, much more out there, but these are our highlights and inspirations.

The [`Monad`](https://hexdocs.pm/monad/Monad.html) library predates `Witchcraft`
by several years. This library proved that it is entirely possible
to bring do-notation to Elixir. It takes a very different approach:
it is very up-front that it has a very loose definition of what it means for
something to be a "monad", and relies on `behaviour`s rather than ad-hoc polymorphism.

[The Fantasy Land Spec](https://github.com/fantasyland/fantasy-land) is a spec for
projects such as this one, but targeted at Javascript. It does not come with its
own implementation, but provides a [helpful chart](https://github.com/fantasyland/fantasy-land/raw/master/figures/dependencies.png)
of class hierarchies.

In many ways, [`Scalaz`](https://github.com/scalaz/scalaz), and later [`cats`](http://typelevel.org/cats/),
were the first widely-used port of categorical & algebraic ideas to
a mainstream language. While dismissed by some as "[Haskell fan fiction](https://twitter.com/plt_hulk/status/341292374355501056)",
it showed that we can write our own Haskell fanfic in all sorts of languages.

Obviously the Haskell [`Prelude`](https://hackage.haskell.org/package/base-4.10.0.0/docs/Prelude.html)
deserves mention. Haskell has inspired so many programmers to write clean,
declarative, functional code based on principled abstractions. We'll spare you
the love letter to [SPJ](https://en.wikipedia.org/wiki/Simon_Peyton_Jones),
the Glasgow team, and the original Haskell committee, but we're deeply appreciative
of how they pushed the state of the art forward.

[`classy-prelude`/`mono-traversable`](https://github.com/snoyberg/mono-traversable)
have also made a lot of progress towards a base library that incorporates modern ideas
in a clean package, and was an inspiration to taking a similar approach with Witchcraft.

The [`semigroupoids`](https://hackage.haskell.org/package/semigroupoids) library
from the eminent [Edward Kmett](https://github.com/ekmett) provided many
reference implementations and is helping set the future expansion of
the foldable class lineage in Witchcraft.

Interested in learning more of the underlying ideas? The maintainers can heavily
recommend [Conceptual Mathematics](http://www.cambridge.org/catalogue/catalogue.asp?isbn=9780521719162),
[Category Theory for the Sciences](https://mitpress.mit.edu/books/category-theory-sciences),
and [Categories for the Working Mathematician](https://en.wikipedia.org/wiki/Categories_for_the_Working_Mathematician).
Reading these books probably won't change your code overnight. Some people call it
"[general abstract nonsense](https://en.wikipedia.org/wiki/Abstract_nonsense)"
for a reason. That said, it does provide a nice framework for thinking about
these abstract ideas, and is a recommended pursuit for all that are curious.

## Credits

### Logo
A big thank you to [Brandon Labbé](https://dribbble.com/brandonlabbe) for creating
the project logo.

### Sponsor
[Robot Overlord](http://robotoverlord.io) sponsors much of the development of Witchcraft,
and dogfoods the library in real-world applications.
