defmodule Witchcraft.Monad.AST do
  import Witchcraft.Applicative

  def preprocess(input, datatype) do
    Macro.prewalk(normalize(input), fn
      {:return, _ctx, [inner]} -> quote do: pure(unquote(datatype), unquote(inner))
      ast -> ast
    end)
  end

  def normalize({:__block__, _, inner}), do: inner
  def normalize(plain), do: List.wrap(plain)
end
