defmodule Witchcraft.Monoid.Operator do
  import Kernel, except: [<>: 2]
  import Witchcraft.Monoid, only: [append: 2]

  defmacro __using__(_) do
    quote do
      import Kernel, except: [<>: 2]
      import Witchcraft.Monoid.Operator, only: [<>: 2]
    end
  end

  @doc ~S"""
  Infix variant of `Monoid.append`

  # Example

  ```elixir

  iex> import Witchcraft.Monoid
  ...> defimpl Witchcraft.Monoid, for: Integer do
  ...>   def identity(_), do: 0
  ...>   def append(a, b), do: a + b
  ...> end
  iex> 1 |> append(4) |> append(2) |> append(10)
  17

  iex> use Witchcraft.Monoid.Operator
  iex> 1 <> 4 <> 2 <> 10
  17

  iex> import Witchcraft.Monoid
  ...> defimpl Witchcraft.Monoid, for: List do
  ...>   def identity(_), do: []
  ...>   def append(a, b), do: a ++ b
  ...> end
  iex> 1 |> append(4) |> append(2) |> append(10)
  17

  iex> use Witchcraft.Monoid.Operator
  iex> [42, 43] <> [44] <> [45, 46] <> [47]
  [42, 43, 44, 45, 46, 47]

  ```

  """
  @spec any <> any :: any
  def a <> b, do: append(a, b)
end
