defmodule Witchcraft.Utility do
  @doc ~S"""
  Do nothing to an argument; just return it

  # Examples
  ```

  iex> Witchcraft.Utility.id("88 miles per hour")
  "88 miles per hour"

  iex> Witchcraft.Utility.id(42)
  42

  iex> Enum.map([1,2,3], &Witchcraft.Utility.id&1)
  [1,2,3]

  ```
  """
  @spec id(any) :: any
  def id(a), do: a

  @doc ~S"""
  Return the *first* of two arguments. Can be used to repeatedly apply the same value
  in functions such as folds.

  # Examples
  ```

  iex> Witchcraft.Utility.first(43, 42)
  43

  iex> Enum.reduce([1,2,3], [42], &Witchcraft.Utility.first(&1, &2))
  3

  ```
  """
  @spec first(any, any) :: any
  def first(a, _), do: a

  @doc ~S"""
  Return the *second* of two arguments. Can be used to repeatedly apply the same value
  in functions such as folds.

  # Examples
  ```

  iex> Witchcraft.Utility.second(43, 42)
  42

  iex> Enum.reduce([1,2,3], [], &Witchcraft.Utility.second(&1, &2))
  []

  ```
  """
  @spec second(any, any) :: any
  def second(_, b), do: b

  @doc "Alias for `second/2`"
  @spec constant(any, any) :: any
  def constant(_, b), do: b

  @doc """
  Function composition, from the back of the lift to the front

  # Example
  iex> sum_plus_one = Witchcraft.Utility.compose([&(&1 + 1), &(Enum.sum(&1))])
  iex> [1,2,3] |> sum_plus_one.()
  7
  """
  @spec compose([(... -> any)]) :: (... -> any)
  def compose(func_list) do
    List.foldr(func_list, &(id(&1)), fn(f, acc) -> &(f.(acc.(&1))) end)
  end

  @doc ~S"""
  Compose functions, from the head of the list of functions. The is the reverse
  order versus what one would normally expect (left to right rather than right to left).

  # Example
  iex> sum_plus_one = Witchcraft.Utility.reverse_compose([&(Enum.sum(&1)), &(&1 + 1)])
  iex> [1,2,3] |> sum_plus_one.()
  7
  """
  @spec reverse_compose([(... -> any)]) :: (... -> any)
  def reverse_compose(func_list) do
    Enum.reduce(func_list, &(id(&1)), fn(f, acc) -> &(f.(acc.(&1))) end)
  end

  defmodule Id do
    @moduledoc ~S"""
    A simple container. Mainly used to show example implimentations of this library.
    """
    defstruct id: nil

    def is_id(%Witchcraft.Utility.Id{id: _}), do: true
    def is_id(_), do: false
  end
end
