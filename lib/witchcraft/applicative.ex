import TypeClass

defclass Witchcraft.Applicative do
  extend Witchcraft.Apply

  where do
    def of(sample, to_wrap)
  end

  defalias wrap(sample, to_wrap), as: :wrap
  defalias pure(sample, to_wrap), as: :wrap

  properties do
    use Witchcraft.Apply

    def identity(data) do
      a = generate(data)
      f = &Quark.id/1

      a == (a ~>> Applicative.of(a, f))
    end

    def homomorphism(data) do
      a = generate(data)
      f = &inspect/1

      left  = Applicative.of(data, f) ~>> Applicative.of(data, a)
      right = Applicative.of(data, f.(a))

      left == right
    end

    def interchange(data) do
      as = generate(data)
      fs = replace(as, &inspect/1)

      left  = fs <<~ Applicative.of(fs, as)
      right = Applicative.of(fs, fn g -> g.(as) end) <<~ fs

      left == right
    end
  end
end

# definst Witchcraft.Applicative, for: Functio💯n do
#   def wrap(fun) when is_function(fun), do: &Quark.SKI.k/1
# end
