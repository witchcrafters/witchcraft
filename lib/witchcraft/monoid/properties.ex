defmodule Witchcraft.Monoid.Properties do
  @moduledoc """
  Check samples to confirm that your data adheres to monoidal properties
  """

  import Witchcraft.Monoid
  import Witchcraft.Monoid.Functions

  @spec confirm_membership([any]) :: boolean
  def confirm_membership(candidates) do
    Enum.reduce(candidates, true, &(&2 and member?(&1)))
  end

  @spec spotcheck_identity(any) :: boolean
  def spotcheck_identity(member) do
    (Mon.identity(member) <|> member) == member
  end

  @spec spotcheck_associativity(any, any, any) :: boolean
  def spotcheck_associativity(member1, member2, member3) do
    (member1 <|> (member2 <|> member3)) == ((member1 <|> member2) <|> member3)
  end

  @spec spotcheck(any, any, any) :: boolean
  def spotcheck(a, b, c) do
    confirm_membership([a, b, c]) and spotcheck_identity(a) and spotcheck_associativity(a, b, c)
  end
end
