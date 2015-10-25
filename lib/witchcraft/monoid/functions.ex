defmodule Witchcraft.Monoid.Functions do
  alias Witchcraft.Monoid, as: Mon

  @doc ~S"""
  Infix variant of `Monoid.op`

  # Example
  ```

  iex> alias Witchcraft.Monoid, as: Monoid
  iex> defimpl Monoid, for: Integer do
  iex>   def identity(_), do: 0
  iex>   def op(a, b), do: a + b
  iex> end
  iex> Monoid.op(1, 4) |> Monoid.op 2 |> Monoid.op 10
  17
  iex> 1 <|> 4 <|> 2 <|> 10
  17

  ```
  """
  @spec any <|> any :: any
  def a <|> b, do: Mon.op(a, b)
end
