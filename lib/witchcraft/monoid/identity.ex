defmodule Witchcraft.Monoid.Identity do
  @moduledoc "Get the identity without providing a sample value"
  @callback identity() :: any
end
