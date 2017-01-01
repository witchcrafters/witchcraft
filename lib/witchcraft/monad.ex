import TypeClass

defclass Witchcraft.Monad do
  extend Witchcraft.Applicative
  extend Witchcraft.Chainable

  alias Witchcraft.Monad.AST
  import Witchcraft.Chainable

  defmacro monad(do: input) do
    Witchcraft.Foldable.foldr(Enum.reverse(AST.normalize(input)), fn
      (ast = {:<-, ctx, inner = [old_left = {lt, lc, lb}, right]}, acc) ->
        left = {lt, lc, nil}
        case acc do
          {:fn, _, _} ->
            quote do: unquote(right) >>> fn unquote(left) -> unquote(acc).(unquote(left)) end

          acc ->
            quote do: unquote(right) >>> fn unquote(left) -> unquote(acc) end
        end

      (ast, acc) -> quote do: bind_forget(unquote(ast), unquote(acc))
    end)
    |> fn x ->
      IO.puts(inspect x)
      x
    end.()
  end

  defmacro monad(datatype, do: input) do
    quote do: monad(do: unquote(AST.preprocess(input, datatype)))
  end

  defmacro let(left, do: right), do: quote do: unquote(left) = unquote(right)

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
