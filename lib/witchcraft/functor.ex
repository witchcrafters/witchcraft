import TypeClass

defclass Witchcraft.Functor do
  @moduledoc ~S"""
  Functors are datatypes that allow the application of functions to their interior values.
  Always returns data in the same structure (same size, tree layout, and so on).

  Please note that bitstrings are not functors, as they fail the
  functor composition constraint. They change the structure of the underlying data,
  and thus composed lifting does not equal lifing a composed function. If you
  need to map over a bitstring, convert it to and from a charlist.

  ## Type Class

  An instance of `Witchcraft.Functor` must define `Witchcraft.Functor.map/2`.

      Functor  [map/2]
  """

  alias __MODULE__
  use Quark

  @type t :: any()

  defmacro __using__(opts \\ []) do
    quote do
      import unquote(__MODULE__), unquote(opts)
    end
  end

  where do
    @doc ~S"""
    `map` a function into one layer of a data wrapper.
    There is an autocurrying variant: `lift/2`.

    ## Examples

        iex> map([1, 2, 3], fn x -> x + 1 end)
        [2, 3, 4]

        iex> %{a: 1, b: 2} ~> fn x -> x * 10 end
        %{a: 10, b: 20}

        iex> map(%{a: 2, b: [1, 2, 3]}, fn
        ...>   int when is_integer(int) -> int * 100
        ...>   value -> inspect(value)
        ...> end)
        %{a: 200, b: "[1, 2, 3]"}

    """
    def map(wrapped, fun)
  end

  properties do
    def identity(data) do
      wrapped = generate(data)

      wrapped
      |> Functor.map(&id/1)
      |> equal?(wrapped)
    end

    def composition(data) do
      wrapped = generate(data)

      f = fn x -> inspect(wrapped == x) end
      g = fn x -> inspect(wrapped != x) end

      left  = Functor.map(wrapped, fn x -> x |> g.() |> f.() end)
      right = wrapped |> Functor.map(g) |> Functor.map(f)

      equal?(left, right)
    end
  end

  @doc ~S"""
  `map/2` but with the function automatically curried

  ## Examples

      iex> lift([1, 2, 3], fn x -> x + 1 end)
      [2, 3, 4]

      iex> [1, 2, 3]
      ...> |> lift(fn x -> x + 55 end)
      ...> |> lift(fn y -> y * 10 end)
      [560, 570, 580]

      iex> [1, 2, 3]
      ...> |> lift(fn(x, y) -> x + y end)
      ...> |> List.first()
      ...> |> apply([9])
      10

  """
  @spec lift(Functor.t(), fun()) :: Functor.t()
  def lift(wrapped, fun), do: Functor.map(wrapped, curry(fun))

  @doc ~S"""
  Operator alias for `lift/2`

  ## Example

      iex> [1, 2, 3]
      ...> ~> fn x -> x + 55 end
      ...> ~> fn y -> y * 10 end
      [560, 570, 580]

      iex> [1, 2, 3]
      ...> ~> fn(x, y) -> x + y end
      ...> |> List.first()
      ...> |> apply([9])
      10

  """
  defalias data ~> fun, as: :lift

  @doc ~S"""
  `<~/2` with arguments flipped.

      iex> (fn x -> x + 5 end) <~ [1,2,3]
      [6, 7, 8]

  Note that the mnemonic is flipped from `|>`, and combinging directions can
  be confusing. It's generally recommended to use `~>`, or to keep `<~` on
  the same line both of it's arguments:

      iex> fn(x, y) -> x + y end <~ [1, 2, 3]
      ...> |> List.first()
      ...> |> apply([9])
      10

  ...or in an expression that's only pointing left:

      iex> fn y -> y * 10 end
      ...> <~ fn x -> x + 55 end
      ...> <~ [1, 2, 3]
      [560, 570, 580]

  """
  def fun <~ data, do: data ~> fun

  @doc ~S"""
  Replace all inner elements with a constant value

  ## Examples

      iex> replace([1, 2, 3], "hi")
      ["hi", "hi", "hi"]

  """
  @spec replace(Functor.t(), any()) :: Functor.t()
  def replace(wrapped, replace_with), do: wrapped ~> &constant(replace_with, &1)
end

definst Witchcraft.Functor, for: Function do
  use Quark

  @doc """
  Compose functions

  ## Example

      iex> ex = Witchcraft.Functor.lift(fn x -> x * 10 end, fn x -> x + 2 end)
      ...> ex.(2)
      22

  """
  def map(f, g), do: compose(g, f)
end

definst Witchcraft.Functor, for: List do
  def map(list, fun), do: Enum.map(list, fun)
end

definst Witchcraft.Functor, for: Tuple do
  def map(tuple, fun) do
    case tuple do
      {} ->
        {}

      {first} ->
        {fun.(first)}

      {first, second} ->
        {first, fun.(second)}

      {first, second, third} ->
        {first, second, fun.(third)}

      {first, second, third, fourth} ->
        {first, second, third, fun.(fourth)}

      {first, second, third, fourth, fifth} ->
        {first, second, third, fourth, fun.(fifth)}

      big_tuple ->
        last_index = tuple_size(big_tuple) - 1

        mapped =
          big_tuple
          |> elem(last_index)
          |> fun.()

        put_elem(big_tuple, last_index, mapped)
    end
  end
end

definst Witchcraft.Functor, for: Map do
  def map(hashmap, fun) do
    hashmap
    |> Map.to_list()
    |> Witchcraft.Functor.map(fn {key, value} -> {key, fun.(value)} end)
    |> Enum.into(%{})
  end
end
