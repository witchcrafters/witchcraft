defmodule Witchcraft.Id do
  @moduledoc ~S"""
  A simple wrapper for some data. Only used in this library for examples.

  If you are interested in this type of functionality, please take a look at
  [Algae](https://github.com/robot-overlord/algae).
  """
  @type t :: %Witchcraft.Id{id: any}
  defstruct [:id]
end
