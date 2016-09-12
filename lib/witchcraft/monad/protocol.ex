defprotocol Witchcraft.Monad.Protocol do
  @moduledoc ~S"""
  Because we are following the `Functor -> Applicative -> Monad` hierarchy,
  `return` is already defined as `pure`. `bind` can be defined in terms of `join`
  and `lift`, so we only need to define `join` for monads.
  """

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
