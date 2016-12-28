import TypeClass

defclass Witchcraft.Monoid do
  @moduledoc ~S"""
  Monoid extends the semigroup with the concept of an "empty" or "zero" element.

  ## Examples

      iex> empty(10)
      0

      iex> empty [1, 2, 3, 4, 5]
      []

  """

  alias Witchcraft.Monoid
  extend Witchcraft.Semigroup, alias: true

  where do
    @doc ~S"""
    An "emptied out" or "starting position" of the passed data

    ## Example

        iex> empty(10)
        0

        iex> empty [1, 2, 3, 4, 5]
        []

    """
    def empty(sample)
  end

  defdelegate zero(sample), to: Proto, as: :empty

  @spec empty?(Monoid.t) :: boolean
  def empty?(monoid), do: empty(monoid) == monoid

  properties do
    def left_identity(data) do
      a = generate(data)
      Semigroup.concat(Monoid.empty(a), a) == a
    end

    def right_identity(data) do
      a = generate(data)
      Semigroup.concat(a, Monoid.empty(a)) == a
    end
  end
end

definst Witchcraft.Monoid, for: Integer do
  def empty(_), do: 0
end

definst Witchcraft.Monoid, for: Float do
  def empty(_), do: 0.0
end


definst Witchcraft.Monoid, for: BitString do
  def empty(_), do: ""
end

definst Witchcraft.Monoid, for: List do
  def empty(_), do: []
end

definst Witchcraft.Monoid, for: Map do
  def empty(_), do: %{}
end
