import TypeClass

defclass Witchcraft.Applicative do
  extend Witchcraft.Apply

  where do
    def wrap(sample, to_wrap)
  end

  defalias of(sample),   as: :wrap
  defalias pure(sample), as: :wrap

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

      left  = Applicative.wrap(data, f) ~>> Applicative.wrap(data, a)
      right = Applicative.wrap(data, f.(a))

      left == right
    end

    def interchange(data) do
      as = generate(data)
      fs = Functor.replace(as, &inspect/1)

      left  = fs <<~ Applicative.wrap(fs, as)
      right = Applicative.wrap(fs, fn g -> g.(as) end) <<~ fs

      left == right
    end
  end
end
