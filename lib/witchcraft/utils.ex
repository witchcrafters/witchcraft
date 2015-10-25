defmodule Witchcraft.Utils do
  def id(a), do: a
  def const(a, _), do: a

  @doc """
  Compose functions

  # Example
  iex> sum_plus_one = compose([&(Enum.sum(&1)), &(&1 + 1)])
  iex> [1,2,3] |> sum_plus_one.()
  7
  """
  @spec compose([(... -> any)]) :: (... -> any)
  def compose(func_list) do
    Enum.reduce(func_list, &(id(&1)), fn(f, acc) -> &(f.(acc.(&1))) end)
  end
end
