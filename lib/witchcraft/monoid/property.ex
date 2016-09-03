defmodule Witchcraft.Monoid.Property do
  @moduledoc """
  Check samples of your monoid to confirm that your data adheres to the
  monoidal properties. *All members* of your datatype should adhere to these rules.
  They are placed here as a quick way to spotcheck some of your values.
  """

  import Witchcraft.Monoid
  import Witchcraft.Monoid.Operator, only: [<|>: 2]

  @doc ~S"""
  Check that some member of your monoid combines with the identity to return itself

      iex> spotcheck_identity("well formed")
      true

      # Float under division
      iex> spotcheck_identity(%Witchcraft.Sad{})
      false

  """
  @spec spotcheck_identity(any) :: boolean
  def spotcheck_identity(member), do: (identity(member) <|> member) == member

  @doc ~S"""
  Check that `Monoid.append` is [associative](https://en.wikipedia.org/wiki/Associative_property)
  (ie: brackets don't matter)

      iex> spotcheck_associativity("a", "b", "c")
      true

      # Float under division
      iex> spotcheck_associativity(%Witchcraft.Sad{sad: -9.1}, %Witchcraft.Sad{sad: 42.0}, %Witchcraft.Sad{sad: 88.8})
      false

  """
  @spec spotcheck_associativity(any, any, any) :: boolean
  def spotcheck_associativity(member1, member2, member3) do
    (member1 <|> (member2 <|> member3)) == ((member1 <|> member2) <|> member3)
  end

  @doc """
  Spotcheck all monoid properties

      iex> spotcheck(1,2,3)
      true

      # Float under division
      iex> spotcheck(%Witchcraft.Sad{sad: -9.1}, %Witchcraft.Sad{sad: 42.0}, %Witchcraft.Sad{sad: 88.8})
      false

  """
  @spec spotcheck(any, any, any) :: boolean
  def spotcheck(a, b, c) do
    spotcheck_identity(a) and spotcheck_associativity(a, b, c)
  end
end
