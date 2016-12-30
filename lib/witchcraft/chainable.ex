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

  def join(nested), do: nested >>> &Quark.id/1
  defalias flatten(nested), as: :join

  properties do
    def associative(data) do
      a = generate(data)
      b = generate(data)

      f = &Witchcraft.Functor.replace(b, &1)
      g = &Witchcraft.Functor.replace(a, inspect(&1))

      left  = a |> Chainable.chain(f) |> Chainable.chain(g)
      right = a |> Chainable.chain(fn x -> x |> f.() |> Chainable.chain(g) end)

      equal?(left, right)
    end
  end
end
