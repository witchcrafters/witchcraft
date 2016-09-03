defprotocol Witchcraft.Monoid.Protocol do
  @moduledoc ~S"""
  TODO WRITE STUFF

  # Notes
  You can of course abuse this protocol to define a fake 'monoid' that behaves differently.
  For the protocol to operate as intended, you need to respect the above properties.
  """

  @doc "Get the identity ('zero') element of the monoid by passing in any element of the set"
  @spec identity(any) :: any
  def identity(a)

  @doc "Combine two members of the monoid, and return another member"
  @spec append(any, any) :: any
  def append(a, b)
end

defimpl Witchcraft.Monoid, for: Integer do
  @doc ~S"""
      iex> identity(99) == identity(-9)
      true
  """
  def identity(_integer), do: 0

  @doc ~S"""
      iex> 1 |> append(4) |> append(2) |> append(10)
      17
  """
  @spec append(integer, integer) :: integer
  def append(a, b), do: a + b
end

defimpl Witchcraft.Monoid, for: Float do
  @doc ~S"""
      iex> identity(98.5) == identity(-8.5)
      true
  """
  def identity(_integer), do: 0.0

  @doc ~S"""
      iex> 1.0 |> append(4.0) |> append(2.0) |> append(10.1)
      17.1
  """
  def append(a, b), do: a + b
end

defimpl Witchcraft.Monoid, for: BitString do
  @doc ~S"""
      iex> "welp" |> identity |> append("o hai")
      "o hai"
  """
  def identity(_), do: ""

  @doc ~S"""
      iex> append("o hai", identity("welp"))
      "o hai"

      iex> identity("") |> append(identity("")) == identity("")
      true
  """
  def append(a, b), do: a <> b
end

defimpl Witchcraft.Monoid, for: List do
  def identity(_list), do: []
  def append(as, bs), do: as ++ bs
end

defimpl Witchcraft.Monoid, for: Map do
  def identity(_map), do: %{}
  def append(ma, mb), do: Dict.merge(ma, mb)
end

defimpl Witchcraft.Monoid, for: Witchcraft.Sad do
  def identity(%Witchcraft.Sad{sad: _}), do: %Witchcraft.Sad{}
  def append(%Witchcraft.Sad{sad: a}, %Witchcraft.Sad{sad: b}), do: %Witchcraft.Sad{sad: a / b}
end
