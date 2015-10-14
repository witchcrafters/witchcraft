defprotocol Witchcraft.Applicative do
  @moduledoc ~S"""
  Applicative functors provide a method of applying a function contained in a
  datatype to a value of the same datatype.
  """

  @fallback_to_any true

  # Lift
  @spec pure(any) :: any
  def pure(member)

  # Sequential application
  @spec apply(%Struct{}, %Struct{}) :: any
  def apply(data, function)
end

defimpl Witchcraft.Applicative, for: Witchcraft.ADT.Maybe do
  def pure(a), do: %Maybe{maybe: a}
end

defimpl Witchcraft.Applicative, for: Witchcraft.ADT.MaybePlus do
  def pure(a), do: %MaybePlus{maybe: a}
end
