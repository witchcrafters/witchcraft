defprotocol Witchcraft.Applicative do
  @moduledoc ~S"""
  """

  @type pure(a) :: {a}

  @fallback_to_any true

  # Lift
  @spec pure(any) :: pure(any)
  def pure(member)

  # Sequential application
  @spec apply((any -> any), any) :: any
  def apply(collection, function)
end
