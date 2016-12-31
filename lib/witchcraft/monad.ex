import TypeClass

defclass Witchcraft.Monad do
  extend Witchcraft.Applicative
  extend Witchcraft.Chainable

  # add return unquote(datatype), inner
  defmacro monad(data, do: body) do
    quote do
      monad do: fn witchcraft_monad -> unquote(body) end.(unquote(data))
    end
  end

  defmacro monad(do: {:__block__, ctx, body}) do
    # [witchcraft_monad | body]
    # body
    # |> Enum.reverse
    # |> Enum.reduce([], fn
      # ({:<-, ctx, [variables, inner_body]}, acc) ->
      #   quote do
      #     # Witchcraft.Chainable.bind(unquote(inner_body), fn
      #     #   (unquote_splicing(List.wrap(variables))) -> unquote_splicing(acc)
      #     # end)
      #   end

      # ({:return, ctx, inner_body}, acc) ->
      #   quote do
      #     Witchcraft.Monad.return(witchcraft_monad, unquote(inner_body))
      #   end

      # (ast = {:<-, _, _}, acc) -> quote do: unquote(ast).(unquote(acc))
      # (ast = {:return, _, inner}, acc) -> quote do: unquote(ast).(Witchcraft.Applicative.of [], unquote_splicing(inner))
      # (ast, acc) -> quote do: fn f -> Witchcraft.Chainable.bindx(unquote(acc), unquote(ast) |> f.()) end
    # end)

    body
    |> Enum.map(fn
      ast = {:<-, _, _} -> ast
      ast = {:return, _, _} -> ast
      ast -> quote do: fn f -> fn _ -> unquote(ast) |> f.() end end
    end)
    |> Witchcraft.Foldable.foldr(&Witchcraft.Chainable.bind/2)
  end

  def return([], body), do: Witchcraft.Applicative.of([], body)

  defmacro monad(do: body) do
    new_body = {:__block__, [], [body]}
    quote do: Witchcraft.Monad.monad(do: unquote(new_body))
  end

  defmacro left <- right do
    quote do
      fn f ->
        fn unquote(left) -> unquote(right) |> f.() end
      end
    end
  end

  defdelegate return(sample, body), to: Witchacrft.Applicative, as: :of

  # defmacro return(body) do
  #   quote do: Witchcraft.Monad.return(@withcraft_monad, unquote(body))
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
