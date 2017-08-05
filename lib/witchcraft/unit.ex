defmodule Witchcraft.Unit do
  @moduledoc """
  The `unit` or `Void` type. A stand in for "no added information here".

  Why not encode unit as `{}`? Many protocols (Witchcraft and others)
  convert tuples to lists, and thus will treat unit as `{}` and thus `[]`,
  which we don't want. The struct removes this ambiguity.
  """

  alias __MODULE__

  @type t :: %Unit{}
  defstruct []

  @doc "Helper to summon the singleton `Unit` struct"
  @spec new() :: t()
  def new, do: %Unit{}
end

defimpl TypeClass.Property.Generator, for: Witchcraft.Unit do
  def generate(_), do: %Witchcraft.Unit{}
end
