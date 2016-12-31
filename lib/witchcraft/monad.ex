import TypeClass

defclass Witchcraft.Monad do
  extend Witchcraft.Applicative
  extend Witchcraft.Chainable

  # add return unquote(datatype), inner
  # defmacro monad(datatype, do: body) do
  #   body
  #   |> Enum.reverse
  #   |> Enum.reduce(fn
  #     ({:<-, ctx, [variables | inner_body]}, acc) ->
  #       quote do
  #         Witchcraft.Chainable.bind(unquote(inner_body), fn
  #           (unquote_splicing(variables)) -> unquote(acc)
  #         end)
  #       end

  #       # {:bind, ctx, [
  #       #     inner_body,
  #       #     {:fn, [], [
  #       #         {:->, [], [
  #       #                 [variables],
  #       #                 {
  #       #                   {:., [], [
  #       #                       {:__aliases__, [alias: false], [:Witchcraft, :Chainable]},
  #       #                       :bind
  #       #                     ]},
  #       #                   [context: Elixir, import: Kernel],
  #       #                   acc
  #       #                 }
  #       #               ]}
  #       #       ]}
  #       #   ]}

  #     (ast, acc) -> quote do: Witchcraft.Chainable.bind_(unquote(acc), unquote(ast))
  #   end)
  # end

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
