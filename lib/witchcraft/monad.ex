import TypeClass

defclass Witchcraft.Monad do
  extend Witchcraft.Applicative
  extend Witchcraft.Chainable

  import Witchcraft.Applicative
  import Witchcraft.Chainable

  defmacro monad(do: input) do
    Witchcraft.Foldable.foldr(normalize_ast(input), fn
      (ast = {:<-, ctx, inner = [left = {lt, lc, lb}, right]}, acc) ->
        inner =
          case acc do
            {:fn, _, _} -> quote do: unquote(acc).(unquote(left))
            acc -> acc
          end

        quote do: unquote(right) >>> fn unquote(left) -> unquote(inner) end

      (ast, acc) -> quote do: bind_forget(unquote(ast), unquote(acc))
    end)
  end
  # IO.puts("BIND+CALL: " <> inspect(ast) <> " <<>> " <> inspect(acc))
  # IO.puts("BIND: " <> inspect(ast) <> " <<>> " <> inspect(acc))
  # IO.puts("FORGET: " <> inspect(ast) <> " <<>> " <> inspect(acc))
  # |> fn x ->
  #   IO.puts("OUTPUT: " <> inspect x)
  #   x
  # end.()

  defmacro monad(datatype, do: input) do
    transformed_ast =
      input
      |> normalize_ast
      |> Macro.prewalk(fn
        {:return, _ctx, [inner]} ->
          IO.puts("convert: " <> inspect inner)
          quote do: pure(unquote(datatype), unquote(inner))
        ast -> ast
      end)

    quote do: monad(do: unquote(transformed_ast))
  end

  def normalize_ast(ast) do
    IO.puts ("NORMALIZE" <> inspect ast)
    case ast do
      block =  {:__block__, _, inner} -> inner
      plain -> List.wrap(plain)
    end
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

  # defdelegate return(sample, body), to: Witchacrft.Applicative, as: :of

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
