import TypeClass

defclass Witchcraft.Semigroup do
  @moduledoc ~S"""
  A semigroup is a structure describing data that can be concatenated with others of its type.
  That is to say that concatenating two lists returns a list, concatenating two
  maps returns a map, concatenating two integers returns an integer, and so on.

  These can be chained together an arbitrary number of times. For example:

      1 <> 2 <> 3 <> 5 <> 7 == 18
      [1, 2, 3] <> [4, 5, 6] <> [7, 8, 9] == [1, 2, 3, 4, 5, 6, 7, 8, 9]
      "foo" <> " " <> "bar" == "foo bar"

  This generalizes the idea of a monoid, as it does not require an `empty` version.
  """

  alias __MODULE__
  import Kernel, except: [<>: 2]

  @type t :: any

  defmacro __using__(_) do
    quote do
      import Kernel, except: [<>: 2]
      import unquote(__MODULE__)
    end
  end

  where do
    @doc ~S"""
    `concat`enate two data of the same type. Can be chained an arbitrary number of times.
    These can be chained together an arbitrary number of times. For example:

        iex> 1 |> concat(2) |> concat(3)
        6

        iex> [1, 2, 3]
        ...> |> concat([4, 5, 6])
        ...> |> concat([7, 8, 9])
        [1, 2, 3, 4, 5, 6, 7, 8, 9]

        iex> "foo" |> concat(" ") |> concat("bar")
        "foo bar"

    ## Operator

        iex> use Witchcraft.Semigroup
        ...> 1 <> 2 <> 3 <> 5 <> 7
        18

        iex> use Witchcraft.Semigroup
        ...> [1, 2, 3] <> [4, 5, 6] <> [7, 8, 9]
        [1, 2, 3, 4, 5, 6, 7, 8, 9]

        iex> use Witchcraft.Semigroup
        ...> "foo" <> " " <> "bar"
        "foo bar"

    There is an operator alias `a <> b`. Since this conflicts with `Kernel.<>/2`,
    `use Witchcraft,Semigroup` will automatically exclude the Kernel operator.
    This is highly recommended, since `<>` behaves the same on bitstrings, but is
    now available on more datatypes.

    """
    def concat(a, b)
  end

  defdelegate a <> b, to: :concat

  @doc ~S"""
  Repeat the contents of a semigroup a certain number of times

  ## Examples

      iex> [1, 2, 3] |> repeat(times: 3)
      [1, 2, 3, 1, 2, 3, 1, 2, 3]

  """
  @spec repeat(Semigroup.t, [times: pos_integer]) :: Semigroup.t
  def repeat(to_repeat, times: times) do
    Stream.repeatedly(fn _ -> to_repeat end)
    |> Stream.take(times)
    |> Enum.reduce(&Semigroup.concat/2)
  end

  properties do
    def associative(data) do
      a = generate(data)
      b = generate(data)
      c = generate(data)

      left  = a |> Semigroup.concat(b) |> Semigroup.concat(c)
      right = Semigroup.concat(a, Semigroup.concat(b, c))

      left == right
    end
  end
end

definst Witchcraft.Semigroup, for: Integer do
  def concat(a, b) when is_integer(b), do: a + b
end

definst Witchcraft.Semigroup, for: BitString do
  def concat(a, b) when is_bitstring(b), do: Kernel.<>(a, b)
end

definst Witchcraft.Semigroup, for: List do
  def concat(a, b) when is_list(b), do: a ++ b
end

definst Witchcraft.Semigroup, for: Map do
  def concat(a, b) when is_map(b), do: Map.merge(a, b)
end
