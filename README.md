![](./logo.png)

`Witchcraft` is a library providing common algebraic and categorical abstractions to Elixir.
(Monoids, functors, monads, arrows, and categories)

| Build Status | Maintainer Message | Documentation | Hosted Package |
|--------------|--------------------|---------------|----------------|
| [![Circle CI](https://circleci.com/gh/robot-overlord/witchcraft/tree/master.svg?style=svg)](https://circleci.com/gh/robot-overlord/witchcraft/tree/master) | ![built with humanity](https://cloud.githubusercontent.com/assets/1052016/11023213/66d837a4-8627-11e5-9e3b-b295fafb1450.png) |[robotoverlord.io/witchcraft](http://www.robotoverlord.io/witchcraft/extra-readme.html) | [Hex](https://hex.pm/packages/witchcraft) |

# Table of Contents
- [Quick Start](#quick-start)
- [Values](#values)
  - [Beginner Friendliness](#beginner-friendliness)
  - [Consistency](#consistency)
    - [Language](#language)
    - [Concept](#concept)
  - [Pedagogy](#pedagogy)
  - [Pragmatism](#pragmatism)
  - [Compatibility](#compatibility)
  - [Testing](#testing)
- [Differences from Haskell](#differences-from-haskell)
  - [Naming](#naming)
  - [Hierarchy](#hierarchy)

# Quick Start

```
def deps do
  [{:witchcraft, "~> 0.4.2"}]
end
```

# Values
## Beginner Friendliness
As much as possible, keep things friendly. Concrete examples are available in the
source code, and a Wiki is in the roadmap.

## Consistency
### Language
Elixir does a lot of things differently from other functional languages. The idea
of a data "subject" being piped though functions is conceptually different from
pure composition of functions that are later applied. `Witchcraft` honours the Elixir
way, and operators point in the direction that data travels.

### Concept
By learning from developments in other languages, we can collapse a lot of ideas into
single concepts (`liftA === liftM`, for instance).

## Pedagogy
You shouldn't have to learn another language just to understand powerful abstractions!
By enabling people to use a language that they already know, and is already in the
same ballpark in terms of values (emphasis on immutability, &c), we can teach and
learn faster.

## Pragmatism
Convincing a company to use a language like Haskell or PureScript can be challenging.
Elixir is gaining a huge amount of interest. Many people have been able to introduce
these concepts into companies using Scala, so we should be able to do the same here.

## Compatibility
`Witchcraft` works with [Algae](https://hex.pm/packages/algae), providing `Witchcraft`
instances for all `Algae` data types. There is nothing stopping you from writing your
own implementations for other data types.

# Testing
Each structure is provided a set of rules that it must obey. For convenience, `Witchcraft`
includes property tests to ensure that datatypes that you write are easily property testable
for adherence to their laws. Full compatibility with QuickCheck is coming soon.

# Differences from [Haskell](https://www.haskell.org)
## Naming
Some functions have been renamed for clarity, generality, or style.

| Prelude + Control (Haskell) | Witchcraft (Elixir)   |
|-----------------------------|-----------------------|
| `<>`                        | `<|>`                 |
| `fmap`                      | `lift`                |
| `liftA`                     | `lift`                |
| `liftA2`                    | `lift`                |
| `liftA3`                    | `lift`                |
| `liftM`                     | `lift`                |
| `liftM2`                    | `lift`                |
| `liftM3`                    | `lift`                |
| `apply`                     | `seq`                 |
| `<*>`                       | `<<~` (reverse `~>>`) |
| `*>`                        | `seq_second`          |
| `<*`                        | `seq_first`           |
| `pure`                      | `wrap`                |
| `return`                    | `wrap`                |
| `<$>`                       | `<~` (reverse `~>`)   |
| `>>`                        | `seq_first`           |
| `>>=`                       | `>>>`                 |
| `=<<`                       | `<<<`                 |

## Hierarchy
Having a clean slate, we have been able to use a very clean of typeclasses. Strictly,
all `Applicative`s are `Functor`s, and all `Monad`s are `Applicative`s. This grants
us the ability to reuse functions in their child classes. For example, `pure` can
be used for `return`, `liftA*` is the same as `liftM*`, and so on (see chart above).
