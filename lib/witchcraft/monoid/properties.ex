defmodule Witchcraft.Monoid.Properties do
  @moduledoc """
  Check samples to confirm that your data adheres to monoidal properties
  """

  alias Witchcraft.Monoid, as: Mon

  @type a :: any

  @spec confirm_membership([a]) :: boolean
  def confirm_membership(candidates) do
    Enum.reduce(candidates, true, &(&2 and Mon.member?(&1)))
  end

  # @spec test_id :: boolean
  # def spotcheck_id(member) do
  #   op(id, member) == member
  # end

  # def spotcheck_associativity(member1, member2, member3) do
  #   op(member1, member2) |> op(member3) == member1 |> op(op(member2, member3))
  # end

  # def spotcheck(a, b, c) do
  #   confirm_membership([a, b, c]) and spotcheck_id(a) and spotcheck_associativity(a, b, c)
  # end
end
