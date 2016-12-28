import TypeClass

defclass Witchcraft.Semigroup do
  @moduledoc ~S"""
  A semigroup is a structure describing data that can be appendenated with others of its type.
  That is to say that appending another list returns a list, appending one map
  to another returns a map, and appending two integers returns an integer, and so on.

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
    `append`enate two data of the same type. Can be chained an arbitrary number of times.
    These can be chained together an arbitrary number of times. For example:

        iex> 1 |> append(2) |> append(3)
        6

        iex> [1, 2, 3]
        ...> |> append([4, 5, 6])
        ...> |> append([7, 8, 9])
        [1, 2, 3, 4, 5, 6, 7, 8, 9]

        iex> "foo" |> append(" ") |> append("bar")
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
    def append(a, b)
  end

  defalias a <> b, as: :append

  @doc ~S"""
  Flatten a list of homogeneous semigroups to a single container

  ## Example

      iex> concat [[1, 2, 3], [4, 5, 6]]
      [1, 2, 3, 4, 5, 6]

      iex> concat [%{a: 1, b: 2}, %{c: 3. d: 4}, %{e: 5, f: 6}]
      %{a: 1, b: 2, c: 3: d: 4, e: 5, f: 6}

  """
  @spec concat([Semigroup.t]) :: Semigroup.t
  def concat(list_xs) when is_list(list_xs) do
    Witchcraft.Foldable.fold(list_xs, &Semigroup.append/2)
  end

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
    |> Enum.reduce(&Semigroup.append/2)
  end

  properties do
    def associative(data) do
      a = generate(data)
      b = generate(data)
      c = generate(data)

      left  = a |> Semigroup.append(b) |> Semigroup.append(c)
      right = Semigroup.append(a, Semigroup.append(b, c))

      if is_float(left) and is_float(right) do
        # This is a special case!
        # In theory , a float *is* a semigroup, but due to rounding it fails the
        # automatic prop test. Please voice your opinion if you believe that this
        # shoudl be treated at the machine rounded version rather than the idea of
        # a float: https://github.com/expede/witchcraft/issues/new
        round(left) == round(right)
      else
        left == right
      end
    end
  end
end

definst Witchcraft.Semigroup, for: Integer do
  def append(a, b) when is_integer(b), do: a + b
end

definst Witchcraft.Semigroup, for: Float do
  def append(a, b) when is_float(b), do: a + b
end

definst Witchcraft.Semigroup, for: BitString do
  def append(a, b) when is_bitstring(b), do: Kernel.<>(a, b)
end

definst Witchcraft.Semigroup, for: List do
  def append(a, b) when is_list(b), do: a ++ b
end

definst Witchcraft.Semigroup, for: Map do
  def append(a, b) when is_map(b), do: Map.merge(a, b)
end
