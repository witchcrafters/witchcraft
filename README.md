# Witchcraft
![](./witchcraft-logo.png)

| Build Status | Documentation | Hosted Package |
|--------------|---------------|----------------|
| [![Circle CI](https://circleci.com/gh/robot-overlord/witchcraft/tree/master.svg?style=svg)](https://circleci.com/gh/robot-overlord/witchcraft/tree/master) | [robotoverlord.io/witchcraft](http://www.robotoverlord.io/witchcraft/extra-readme.html) | [Hex](https://hex.pm/packages/witchcraft) |

A monoid, functor, applicative, monad, and arrow library

*This is currently very Haskell-flavoured*. It will become more idiomatic after the first pass.

## Installation

1. Add witchcraft to your list of dependencies in `mix.exs`:

```
def deps do
  [{:witchcraft, "~> 0.2.0"}]
end
```

2. Ensure witchcraft is started before your application:

```
def application do
  [applications: [:witchcraft]]
end
```
