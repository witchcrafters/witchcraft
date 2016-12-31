import TypeClass

defclass Witchcraft.Monad do
  extend Witchcraft.Applicative
  extend Witchcraft.Chainable

  properties do
    import Witchcraft.Applicative
    import Witchcraft.Chainable

    def left_identity(data) do
      a = generate(data)
      b = generate(data)

      f = &Witchcraft.Functor.replace(b, inspect(&1))

      left  = a |> of(a) |> chain(f)
      right = f.(a)

      equal?(left, right)
    end

    def right_identity(data) do
      a = generate(data)
      chain(a, of(a)) |> equal?(a)
    end
  end
end

# List |> conforms(to: Witchcraft.Monad)
# Function |> conforms(to: Monad)
