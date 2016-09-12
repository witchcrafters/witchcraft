defprotocol Witchcraft.Functor.Protocol do

  @doc """
  Apply a function to every element in some collection, tree, or other structure.
  The collection will retain its structure (list, tree, and so on).
  """
  @spec lift(any, (any -> any)) :: any
  def lift(data, function)
end

defimpl Witchcraft.Functor.Protocol, for: List do
  @doc ~S"""
  ## Examples

      iex> lift([1,2,3], &(&1 + 1))
      [2,3,4]

  """
  def lift(data, func), do: Enum.map(data, func)
end
