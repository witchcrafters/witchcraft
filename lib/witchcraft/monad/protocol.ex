defprotocol Witchcraft.Monad.Protocol do
  @moduledoc "The bases for `Witchcraft.Monad`"

  @doc ~S"""
  `join` takes a recursively nested data structure, and joins the two outermost
  levels together to result in one level. This may be seen as a "flattening"
  operation for most datatypes.

  ## Examples

      iex>  join [[[1,2,3]]]
      [[1,2,3]]

  """
  @spec join(any) :: any
  def join(deep)
end

defimpl Witchcraft.Monad.Protocol, for: List do
  def join(list), do: Enum.reduce(list, [], fn(item, acc) -> acc ++ item end)
end
