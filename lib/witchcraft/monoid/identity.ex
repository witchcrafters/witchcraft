defmodule Witchcraft.Monoid.Identity do
  @doc ~S"""
  Get the identity without providing a sample value
  """
  @callback identity() :: any
end
