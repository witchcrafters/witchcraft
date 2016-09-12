defmodule Witchcraft.Applicative.Wrap do
  @moduledoc "Define a wrapping function to lift a value into your struct"
  @callback wrap(any) :: any
end
