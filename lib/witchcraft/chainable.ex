import TypeClass

defclass Witchcraft.Chainable do
  extend Witchcraft.Apply

  @type t :: any

  defmacro __using__(_) do
    quote do
      use Witchcraft.Apply
      import unquote(__MODULE__)
    end
  end

  where do
    def chain(chainable, chain_fun)
  end

  def reverse_chain(chain_fun, chainable), do: chain(chainable, chain_fun)

  defalias bind(chainable, binder), as: :chain
  defalias reverse_bind(chainable, binder), as: :reverse_chain

  defalias chainable >>> chain_fun, as: :chain
  defalias chain_fun <<< chainable, as: :reverse_chain

  def bind_(chainable_a, chainable_b), do: chain(chainable_a, fn _ -> chainable_b end)
  def reverse_bind(chainable_b, chainable_a), do: bind_(chainable_a, chainable_b)

  def join(nested), do: nested >>> &Quark.id/1
  defalias flatten(nested), as: :join

  properties do
    def associative(data) do
      a = generate(data)
      b = generate(data)

      f = fn x -> Witchcraft.Applicative.of(data, inspect(x)) end
      g = fn y -> Witchcraft.Applicative.of(data, y <> y) end

      left  = a |> Chainable.chain(f) |> Chainable.chain(g)
      right = a |> Chainable.chain(fn x -> x |> f.() |> Chainable.chain(g) end)

      equal?(left, right)
    end
  end
end

definst Witchcraft.Chainable, for: List do
  def chain(list, chain_fun) do
    list
    |> Witchcraft.Functor.lift(chain_fun)
    |> Witchcraft.Semigroup.concat
  end
end
