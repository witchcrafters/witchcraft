defmodule Witchcraft.Monad.Axioms do
  alias Witchcraft.Applicative, as: A
  alias Witchcraft.Monad, as: M

  def neutral_return(m), do: M.bind(m, &(A.pure &1)) == m
  def neutral_return(x, f) do
    M.bind(A.pure(x), f) == f.(x)
  end

  def rewording(m, f, g) do
    M.bind(M.bind(m, f), g) == M.bind(m, &(M.bind(f.(&1), g)))
  end
end
