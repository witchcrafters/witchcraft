defmodule Witchcraft.Monad.AST do
  @moduledoc false

  @doc false
  def preprocess(input, datatype) do
    # input
    # |> Witchcraft.Chain.AST.normalize()
    Macro.prewalk(input, fn
      {:return, _ctx, [inner]} ->
        quote do: Witchcraft.Applicative.pure(unquote(datatype), unquote(inner))

      ast ->
        ast
    end)
  end
end
