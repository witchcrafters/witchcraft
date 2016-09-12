defmodule Witchcraft.Monoid.Operator do
  @moduledoc "Operator aliases for `Witchcraft.Monoid`"

  import Witchcraft.Monoid, only: [append: 2]
  import Kernel, except: [<>: 2]

  @doc ~S"""
  Infix variant of `Monoid.append`

  ## Examples

      iex> use Witchcraft.Monoid
      ...> 1 |> append(4) |> append(2) |> append(10)
      17

      iex> import Kernel, except: [<>: 2]
      ...> 1 <> 4 <> 2 <> 10
      17

      iex> use Witchcraft.Monoid
      ...> 1 |> append(4) |> append(2) |> append(10)
      17

      iex> import Kernel, except: [<>: 2]
      ...> [42, 43] <> [44] <> [45, 46] <> [47]
      [42, 43, 44, 45, 46, 47]

  """
  @spec any <> any :: any
  def a <> b, do: append(a, b)
end
