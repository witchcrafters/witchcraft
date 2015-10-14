# Witchcraft
![](./witchcraft-logo.png)

A monoid, functor, applicative, monad, and arrow library

*This is currently very Haskell-flavoured*. It will become more idiomatic after the first pass.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add witchcraft to your list of dependencies in `mix.exs`:

        def deps do
          [{:witchcraft, "~> 0.0.1"}]
        end

  2. Ensure witchcraft is started before your application:

        def application do
          [applications: [:witchcraft]]
        end
