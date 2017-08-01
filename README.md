![](https://github.com/expede/witchcraft/raw/master/brand/Wordmark/PNG/WC-wordmark-lrg@2x.png)

`Witchcraft` is a library providing common algebraic and categorical abstractions to Elixir.
Monoids, functors, monads, arrows, categories, and more.

[![Build Status](https://travis-ci.org/expede/witchcraft.svg?branch=master)](https://travis-ci.org/expede/witchcraft) [![Inline docs](http://inch-ci.org/github/expede/witchcraft.svg?branch=master)](http://inch-ci.org/github/expede/witchcraft) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/expede/witchcraft.svg)](https://beta.hexfaktor.org/github/expede/witchcraft) [![hex.pm version](https://img.shields.io/hexpm/v/witchcraft.svg?style=flat)](https://hex.pm/packages/witchcraft) [![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/witchcraft/) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/expede/witchcraft/blob/master/LICENSE)


# README

## Table of Contents

* [Quick Start](#quick-start)
* [Library Family](#library-family)
* [Values](#values)
* [Type Class Hierarchy](#type-class-hierarchy)
* [Operators](#operators)
* [Haskell Translation Table](#haskell-translation-table)
* [Credits](#credits)

## Quick Start

```elixir
def deps do
  [{:witchcraft, "1.0.0-beta"}]
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

* [Quark](https://hex.pm/packages/quark): Standard combinators (`id`, `compose`, &c)
* [TypeClass](https://hex.pm/packages/type_class): Used internally to generate type classes
* [Algae](https://hex.pm/packages/algae): Algebraic data types that implement `Witchcraft` type classes

## Values

### Beginner Friendliness

You shouldn't have to learn another language just to understand powerful abstractions!
By enabling people to use a language that they already know, and is already in the
same ballpark in terms of values (emphasis on immutability, &c), we can teach and
learn faster.

As much as possible, keep things friendly and well explained.
Concrete examples are available via doctests.

### Consistency & Ethos

Elixir does a lot of things differently from other functional languages.
The idea of a data "subject" being piped though functions is conceptually different from
pure composition of functions that are later applied. `Witchcraft` honours the Elixir
way, and operators point in the direction that data travels.

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
     ↓           ↓         ↓         ↓     ↙   ↓   ↘           |
  Category     Monoid     Ord    Traversable  Apply  Bifunctor  |
     ↓                                       ↙    ↘             ↓
   Arrow                            Applicative   Chain       Extend
                                             ↘    ↙             ↓
                                              Monad           Comonad
```

Having a clean slate, we have been able to use a clean of typeclasses. This is largely
taken from the [Fantasy Land Specification](https://github.com/fantasyland/fantasy-land)
and Edward Kmett's [semigroupoids](https://hackage.haskell.org/package/semigroupoids) package.

As usual, all `Applicative`s are `Functor`s, and all `Monad`s are `Applicative`s.
This grants us the ability to reuse functions in their child classes.
For example, `of` can be used for both `pure` and `return`, `lift/*` can handle
both `liftA*` and `liftM*`, and so on.

### Import Chains

It is very common to want everything in a chain. You can import the entire chain
with `use`. For example, you can import the entire library with:

```elixir
use Witchcraft.Monad
```

Any options that you pass to `use` will be propagated all the way down the chain

```elixir
use Witchcraft.Monad, except: [~>: 2]
```

Some modules override `Kernel` operators and functions. While this is generally safe,
if you would like to skip all overrides, pass `override_kernel: false` as an option

```elixir
use Witchcraft.Foldable, override_kernel: false
```

## Operators

| Family       | Function         | Operator |
|-------------:|:-----------------|:---------|
| Setoid       | `equivalent?`    | `==`     |
|              | `nonequivalent?` | `!=`     |
| Ord          | `greater_than?`  | `>`      |
|              | `lesser_than?`   | `<`      |
| Monoid       | `append`         | `<>`     |
| Functor      | `lift`           | `~>`     |
|              | `pipe_ap`        | `~>>`    |
|              | `chain`          | `>>>`    |
|              | `reverse_lift`   | `<~`     |
|              | `ap`             | `<<~`    |
|              | `reverse_chain`  | `<<<`    |
| Semigroupoid | `compose`        | `<\|>`   |
|              | `pipe_compose`   | `<~>`    |
| Arrow        | `product`        | `^^^`    |
|              | `fanout`         | `&&&`    |


## Haskell Translation Table

| Haskell Prelude | Witchcraft    |
|----------------:|:--------------|
| `flip ($)`      | `\|>/2`       |
| `.`             | `<\|>/2`      |
| `<<<`           | `<\|>/2`      |
| `>>>`           | `<~>/2`       |
| `<>`            | `<>/2`        |
| `<$>`           | `<~/2`        |
| `flip (<$>)`    | `~>/2`        |
| `fmap`          | `lift/2`      |
| `liftA`         | `lift/2`      |
| `liftA2`        | `lift/3`      |
| `liftA3`        | `lift/4`      |
| `liftM`         | `lift/2`      |
| `liftM2`        | `lift/3`      |
| `liftM3`        | `lift/4`      |
| `ap`            | `ap/2`        |
| `<*>`           | `<<~/2`       |
| `<**>`          | `~>>/2`       |
| `*>`            | `then/2`      |
| `<*`            | `following/2` |
| `pure`          | `of/2`        |
| `return`        | `of/2`        |
| `>>`            | `then/2`      |
| `>>=`           | `>>>/2`       |
| `=<<`           | `<<</2`       |
| `***`           | `^^^/2`       |
| `&&&`           | `&&&/2`       |

## Credits

### Logo
A big thank you to [Brandon Labbé](https://dribbble.com/brandonlabbe) for creating
the project logo.

### Sponsor
[Robot Overlord](robotoverlord.io) sponsors much of the development of Witchcraft,
and dogfoods the library in real-world applications.
