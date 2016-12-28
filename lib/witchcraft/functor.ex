import TypeClass

defclass Witchcraft.Functor do
  @moduledoc ~S"""
  Functors are datatypes that allow the application of functions to their interior values.
  Always returns data in the same structure (same size, leaves, &c)

  Please note that bitstrings are not functors, as they fail the
  functor composition constraint. They change the structure of the underlying data,
  and thus composed lifting does not equal lifing a composed function. If you
  need to map over a bitstring, convert it to and from a charlist.
  """

  where do
    @doc ~S"""
    `lift` a function into one layer of a data wrapper. Often called `map`
    there is in fact there is a `map` alias.

    ## Examples

        iex> [1, 2, 3] |> lift(fn x -> x + 1 end)
        [2, 3, 4]

        iex> %{a: 1, b: 2} |> fn x -> x * 10 end
        %{a: 10, b: 20}

        iex> lift(%{a: 2, b: [1, 2, 3]}, fn
        ...>   int when is_integer(int) -> int * 100
        ...>   value -> inspect(value)
        ...> end)
        %{a: 200, b: "[1, 2, 3]"}

    """
    def lift(wrapped, fun)
  end

  defalias map(wrapped, fun), as: :lift
  defalias fmap(wrapped, fun), as: :lift

  @doc ~S"""
  Operator alias for `lift/2`

  ## Example

      iex> [1,2,3]
      ...> ~> fn x -> x + 5 end
      ...> ~> fn y -> y * 10 end
      [60, 70, 80]

  """
  defalias data ~> fun, as: :lift

  @doc ~S"""
  `<~/2` with arguments flipped

  ## Examples

      iex> (fn x -> x + 5 end) <~ [1,2,3]
      [6, 7, 8]

  """
  def fun <~ data, do: data ~> fun

  properties do
    def identity(data) do
      wrapped = generate(data)
      Functor.lift(wrapped, &Quark.id/1) == wrapped
    end

    def composition(data) do
      wrapped = generate(data)

      f = fn x -> inspect(wrapped == x) end
      g = fn x -> inspect(wrapped != x) end

      x = wrapped |> Functor.lift(fn x -> x |> g.() |> f.() end)
      y = wrapped |> Functor.lift(g) |> Functor.lift(f)

      x == y
    end
  end
end

definst Witchcraft.Functor, for: List do
  def lift(list, fun), do: Enum.map(list, fun)
end

definst Witchcraft.Functor, for: Tuple do
  def lift(tuple, fun) do
    tuple
    |> Tuple.to_list
    |> Witchcraft.Functor.lift(fun)
    |> List.to_tuple
  end
end

definst Witchcraft.Functor, for: Map do
  def lift(map, fun) do
    map
    |> Map.to_list
    |> Witchcraft.Functor.lift(fn {key, value} -> {key, fun.(value)} end)
    |> Enum.into(%{})
  end
end
