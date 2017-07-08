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

  alias __MODULE__
  use Quark

  @type t :: any

  where do
    @doc ~S"""
    `map` a function into one layer of a data wrapper.
    There is an autocurrying variant: `lift/2`.

    ## Examples

        iex> [1, 2, 3] |> map(fn x -> x + 1 end)
        [2, 3, 4]

        iex> %{a: 1, b: 2} |> fn x -> x * 10 end
        %{a: 10, b: 20}

        iex> map(%{a: 2, b: [1, 2, 3]}, fn
        ...>   int when is_integer(int) -> int * 100
        ...>   value -> inspect(value)
        ...> end)
        %{a: 200, b: "[1, 2, 3]"}

    """
    def map(wrapped, fun)
  end

  @doc ~S"""
  `map/2` but with the function automatically curried
  """
  @spec lift(Functor.t, fun) :: Functor.t
  def lift(wrapped, fun), do: Functor.map(wrapped, curry(fun))

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

  @doc ~S"""
  Replace all inner elements with a constant value

  ## Examples

      iex> [1, 2, 3] |> replace("hi")
      ["hi", "hi", "hi"]

  """
  @spec replace(Functor.t, any) :: Functor.t
  def replace(wrapped, replace_with), do: wrapped ~> &constant(replace_with, &1)

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

      left  = wrapped |> Functor.map(fn x -> x |> g.() |> f.() end)
      right = wrapped |> Functor.map(g) |> Functor.map(f)

      equal?(left, right)
    end
  end
end

# definst Witchcraft.Functor, for: Function do
#   use Quark
#   def map(f, g), do: compose(g, f)
# end

definst Witchcraft.Functor, for: List do
  def map(list, fun), do: Enum.map(list, fun)
end

# definst Witchcraft.Functor, for: Tuple do
#   def map(tuple, fun) do
#     tuple
#     |> Tuple.to_list
#     |> Witchcraft.Functor.map(fun)
#     |> List.to_tuple
#   end
# end

# definst Witchcraft.Functor, for: Map do
#   def map(hashmap, fun) do
#     hashmap
#     |> Map.to_list
#     |> Witchcraft.Functor.map(fn {key, value} -> {key, fun.(value)} end)
#     |> Enum.into(%{})
#   end
# end

definst Witchcraft.Functor, for: Algae.Id do
  def map(%Algae.Id{id: a}, fun), do: %Algae.Id{id: fun.(a)}
end
