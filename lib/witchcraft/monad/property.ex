defmodule Witchcraft.Monad.Property do

  use Witchcraft.Monad

  defmacro spotcheck_left_identity(value, fun) do
    quote do
      monadic = rewrap(unquote(value)) >>> unquote(fun)
      simple  = unquote(value) |> unquote(fun)
      monadic == simple
    end
  end

  def spotcheck_right_identity(value, fun) do
    (value >>> rewrap(value)) == value
  end

  defmacro spotcheck_associativity(value, f, g) do
    quote do
      left  = (unquote(value) >>> unquote(f)) >>> unquote(g)
      right = unquote(value) >>> fn x -> (x |> unquote(f)) >>> unquote(g) end.()
      left == right
    end
  end
end
