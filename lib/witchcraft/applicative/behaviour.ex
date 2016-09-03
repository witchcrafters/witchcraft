defmodule Witchcraft.Applicative.Wrap do
  # NOTE: check if you can fold this into the protocol
  @callback wrap(any) :: any
end
