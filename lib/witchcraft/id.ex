defmodule Witchcraft.Id do
  @moduledoc ~S"""
  A simple wrapper for some data. Only used in this library for examples.

  If you are interested in this type of functionality, please take a look at
  [Algae](https://github.com/robot-overlord/algae).
  """
  @type t :: %Witchcraft.Id{id: any}
  defstruct [:id]

  def is_id(%Witchcraft.Id{id: _}), do: true
  def is_id(_), do: false
end

defmodule Witchcraft.Sad do
  defstruct sad: -9.4
end

defimpl Witchcraft.Monoid, for: Witchcraft.Sad do
  def identity(%Witchcraft.Sad{sad: _}), do: %Witchcraft.Sad{}
  def append(%Witchcraft.Sad{sad: a}, %Witchcraft.Sad{sad: b}), do: %Witchcraft.Sad{sad: a / b}
end
