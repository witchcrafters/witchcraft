import TypeClass

defclass Witchcraft.Monad do
  extend Witchcraft.Applicative
  extend Witchcraft.Chainable

  import Witchcraft.Chainable

  # add return unquote(datatype), inner
  # defmacro monad(data, do: body) do
  #   quote do
  #     monad do: fn witchcraft_monad -> unquote(body) end.(unquote(data))
  #   end
  # end

  defmacro monad(do: input = {:__block__, ctx, body}) do
    IO.puts("INPUT: " <> inspect input)
    Witchcraft.Foldable.foldr(Enum.reverse(body),
      fn
        (ast = {:<-, ctx, inner = [left = {lt, lc, lb}, right]}, acc) ->
          IO.puts("bind: " <> inspect(ast) <> " <<>> " <> inspect(acc))
          quote do
            unquote(right) >>> fn unquote(left) -> unquote(acc) end
          end

        (ast, acc) ->
          IO.puts("FORGET: " <> inspect(ast) <> " <<>> " <> inspect(acc))
          quote do: bind_forget(unquote(ast), unquote(acc))
    end)
    |> fn x ->
      IO.puts("OUTPUT: " <> inspect x)
      x
    end.()
  end

  def return([], body), do: Witchcraft.Applicative.of([], body)

  defmacro monad(do: body) do
    new_body = {:__block__, [], [body]}
    quote do: Witchcraft.Monad.monad(do: unquote(new_body))
  end

  # defmacro left <- right do
  #   quote do
  #     import Witchcraft.Chainable
  #     fn continue ->
  #     end
  #     # fn continue ->
  #     #   unquote(right) >>> fn unquote(left) -> continue end
  #     # end
  #   end
  # end

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
