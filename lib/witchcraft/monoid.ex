defmodule Witchcraft.Monoid do
  @doc """
  Monoids have some unique identity element ("id"), and a combining operation ("op").
  Returns another member of the collection.

  Monoid Properties:
  1. Associativity
  For all a, b, and c: a op (b op c) == (a op b) op c

  2. Identity element
  - Unique element
  - Behaves as an identity with op

  Examples:
  id = 0
  op = &(&1 + &2) # Normal addition
  op(34, id) == 34

  id = 1
  op = &(&1 * &2) # Normal multiplication
  op(42, id) == 42

  Notes:
  You can of course use abuse this protocol to define a fake "monoid" that behaves differently.
  For the protocol to operate as intended, you need to respect the above laws.
  """

  use Behaviour

  defcallback member?(value) :: boolean
  defcallback id :: a
  defcallback op :: a -> a

  def confirm_membership(candidate), do: member?(candidate)
  def confirm_membership([candidates]) do
    Enum.map(candidates, member?) |> Enum.reduce(&(&1 and &2))
  end

  @spec test_id :: boolean
  def spotcheck_id(member) do
    op(id, member) == member
  end

  def spotcheck_associativity(member1, member2, member3) do
    op(member1, member2) |> op(member3) == member1 |> op(op(member2, member3))
  end

  def spotcheck_monoid_laws(a, b, c) do
    confirm_membership([a, b, c]) and spotcheck_id(a) and spotcheck_associativity(a, b, c)
  end
end
