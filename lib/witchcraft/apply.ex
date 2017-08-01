import TypeClass

defclass Witchcraft.Apply do
  @moduledoc """
  An extension of `Witchcraft.Functor`, `Apply` provides a way to map functions
  to their arguments when both are wrapped in the same kind of container.

  For a nice, illustrated introduction,
  see [Functors, Applicatives, And Monads In Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html).

  ## Graphically

  If function application looks like like

      data |> function == result

  and a functor looks like this

      %Container<data> ~> function == %Container<result>

  then an apply looks like

      %Container<data> ~>> %Container<function> == %Container<result>

  which is similar to function application inside containers, plus the ability to
  attach special effects to applications.

                 data --------------- function ---------------> result
      %Container<data> --- %Container<function> ---> %Container<result>

  This lets us do functorial things like

  * continue applying values to a curried function resulting from a `Witchcraft.Functor.lift/2`
  * apply multiple functions to multiple arguments (with lists)
  * propogate some state (like [`Nothing`](https://hexdocs.pm/algae/Algae.Maybe.Nothing.html#content)
  in [`Algae.Maybe`](https://hexdocs.pm/algae/Algae.Maybe.html#content))

  but now with a much larger number of arguments, reuse partially applied functions,
  and run effects with the function container as well as the data container.

  ## Examples

      iex> ap([fn x -> x + 1 end, fn y -> y * 10 end], [1, 2, 3])
      [2, 3, 4, 10, 20, 30]

      iex> import Witchcraft.Functor
      ...> [100, 200]
      ...> ~> fn(x, y, z) ->
      ...>   x * y / z
      ...> end <<~ [5, 2]
      ...>     <<~ [100, 50]
      [5.0, 10.0, 2.0, 4.0, 10.0, 20.0, 4.0, 8.0]
      # ↓                          ↓
      # 100 * 5 / 100          200 * 5 / 50

      %Algae.Maybe.Just{just: 42}
      ~> fn(x, y, z) ->
        x * y / z
      end <<~ %Algae.Maybe.Nothing{}
          <<~ %Algae.Maybe.Just{just: 99}
      #=> %Algae.Maybe.Nothing{}

  ## Type Class

  An instance of `Witchcraft.Apply` must also implement `Witchcraft.Functor`,
  and define `Witchcraft.Apply.ap/2`.

      Functor  [map/2]
         ↓
       Apply   [ap/2]
  """

  extend Witchcraft.Functor

  alias __MODULE__
  alias Witchcraft.Functor

  import Witchcraft.Functor, only: [lift: 2]

  use Quark

  @type t   :: any()
  @type fun :: any()

  defmacro __using__(opts \\ []) do
    quote do
      use Witchcraft.Functor,     unquote(opts)
      import unquote(__MODULE__), unquote(opts)
    end
  end

  where do
    @doc """
    Map/apply arguments to functions, when both are wrapped in the same
    type of data structure.

    ## Examples

        iex> ap([fn x -> x + 1 end, fn y -> y * 10 end], [1, 2, 3])
        [2, 3, 4, 10, 20, 30]

        iex> [100, 200]
        ...> |> Witchcraft.Functor.lift(fn(x, y, z) -> x * y / z end)
        ...> |> ap([5, 2])
        ...> |> ap([100, 50])
        [5.0, 10.0, 2.0, 4.0, 10.0, 20.0, 4.0, 8.0]
        # ↓                          ↓
        # 100 * 5 / 100          200 * 5 / 50

    """
    @spec ap(Apply.t(), Apply.fun()) :: Apply.t()
    def ap(wrapped_args, wrapped_funs)
  end

  properties do
    def composition(data) do
      alias Witchcraft.Functor
      use Quark

      as = data |> generate() |> Functor.map(&inspect/1)
      fs = data |> generate() |> Functor.replace(fn x -> x <> x end)
      gs = data |> generate() |> Functor.replace(fn y -> y <> "foo" end)

      left  = Apply.ap(Apply.ap(as, gs), fs)

      right =
        fs
        |> Functor.lift(&compose/2)
        |> fn x -> Apply.ap(gs, x) end.()
        |> fn y -> Apply.ap(as, y) end.()

      equal?(left, right)
    end
  end

  @doc """
  Pipe-ordered application. NOT just a flipped version of `ap/2`.

  This isn't just a flipped `ap` in order to get correct effect sequencing.

  ## Examples

      iex> [1, 2, 3]
      ...> |> reverse_ap([fn x -> x + 1 end, fn y -> y * 10 end])
      [2, 10, 3, 20, 4, 30]

  """
  @spec reverse_ap(Apply.fun(), Apply.t()) :: Apply.t()
  def reverse_ap(wrapped_funs, wrapped), do: ap(wrapped, wrapped_funs)

  @doc """
  Operator alias for `ap/2`

  Moves against the pipe direction, but in the order of normal function application

  ## Examples

      iex> [fn x -> x + 1 end, fn y -> y * 10 end] <<~ [1, 2, 3]
      [2, 3, 4, 10, 20, 30]

      iex> import Witchcraft.Functor
      ...>
      ...> [100, 200]
      ...> ~> fn(x, y, z) -> x * y / z
      ...> end <<~ [5, 2]
      ...>     <<~ [100, 50]
      ...> ~> fn x -> x + 1 end
      [6.0, 11.0, 3.0, 5.0, 11.0, 21.0, 5.0, 9.0]

      iex> import Witchcraft.Functor, only: [<~: 2]
      ...> fn(a, b, c, d) -> a * b - c + d end <~ [1, 2] <<~ [3, 4] <<~ [5, 6] <<~ [7, 8]
      [5, 6, 4, 5, 6, 7, 5, 6, 8, 9, 7, 8, 10, 11, 9, 10]

  """
  defalias wrapped_funs <<~ wrapped, as: :curried_reverse_ap

  @doc """
  Operator alias for `reverse_ap/2`, moving in the pipe direction

  ## Examples

      iex> [1, 2, 3] ~>> [fn x -> x + 1 end, fn y -> y * 10 end]
      [2, 3, 4, 10, 20, 30]

      iex> import Witchcraft.Functor
      ...>
      ...> [100, 50]
      ...> ~>> ([5, 2]     # Note the bracket
      ...> ~>> ([100, 200] # on both `Apply` lines
      ...> ~> fn(x, y, z) -> x * y / z end))
      [5.0, 10.0, 2.0, 4.0, 10.0, 20.0, 4.0, 8.0]

  """
  defalias wrapped ~>> wrapped_funs, as: :curried_ap

  @doc """
  Same as `ap/2`, but with all functions curried

  ## Examples

      iex> [&+/2, &*/2]
      ...> |> curried_ap([1, 2, 3])
      ...> |> ap([4, 5, 6])
      [5, 6, 7, 6, 7, 8, 7, 8, 9, 4, 5, 6, 8, 10, 12, 12, 15, 18]

  """
  @spec curried_ap(Apply.t(), Apply.fun()) :: Apply.t()
  def curried_ap(wrapped_args, wrapped_funs) do
    wrapped_funs
    |> Functor.map(&curry/1)
    |> Apply.reverse_ap(wrapped_args)
  end

  @doc """
  Same as `reverse_ap/2`, but with all functions curried

  ## Examples

      iex> [1, 2, 3]
      ...> |> curried_reverse_ap([fn x -> x + 1 end, fn y -> y * 10 end])
      [2, 3, 4, 10, 20, 30]

  """
  @spec curried_reverse_ap(Apply.fun(), Apply.t()) :: Apply.t()
  def curried_reverse_ap(wrapped_funs, wrapped_args) do
    curried_ap(wrapped_args, wrapped_funs)
  end

  @doc """
  Sequence actions, replacing the first/previous values with the last argument

  This is essentially a sequence of actions forgetting the first argument

  ## Examples

      iex> [1, 2, 3]
      ...> |> then([4, 5, 6])
      ...> |> then([7, 8, 9])
      [
        7, 8, 9,
        7, 8, 9,
        7, 8, 9,
        7, 8, 9,
        7, 8, 9,
        7, 8, 9,
        7, 8, 9,
        7, 8, 9,
        7, 8, 9
      ]

      iex> {1, 2, 3} |> then({4, 5, 6}) |> then({7, 8, 9})
      {12, 15, 9}

  """
  @spec then(Apply.t(), Apply.t()) :: Apply.t()
  def then(wrapped_a, wrapped_b), do: lift(wrapped_a, wrapped_b, &Quark.constant(&2, &1))

  @doc """
  Sequence actions, replacing the last argument with the first argument's values

  This is essentially a sequence of actions forgetting the second argument

  ## Examples

      iex> [1, 2, 3]
      ...> |> following([3, 4, 5])
      ...> |> following([5, 6, 7])
      [
        1, 1, 1, 1, 1, 1, 1, 1, 1,
        2, 2, 2, 2, 2, 2, 2, 2, 2,
        3, 3, 3, 3, 3, 3, 3, 3, 3
      ]

      iex> {1, 2, 3} |> following({4, 5, 6}) |> following({7, 8, 9})
      {12, 15, 3}

  """
  @spec following(Apply.t(), Apply.t()) :: Apply.t()
  def following(wrapped_a, wrapped_b), do: lift(wrapped_a, wrapped_b, &Quark.constant/2)

  @doc """
  Extends `Functor.lift/2` to apply arguments to a binary function

  ## Examples

      iex> lift([1, 2], [3, 4], &+/2)
      [4, 5, 5, 6]

      iex> [1, 2]
      ...> |> lift([3, 4], &*/2)
      [3, 4, 6, 8]

  """
  @spec lift(Apply.t(), Apply.t(), fun()) :: Apply.t()
  def lift(a, b, fun), do: a |> lift(fun) |> reverse_ap(b) # pass(b)?

  @doc """
  Extends `lift` to apply arguments to a ternary function

  ## Examples

      iex> lift([1, 2], [3, 4], [5, 6], fn(a, b, c) -> a * b - c end)
      [-2, -3, -1, -2, 1, 0, 3, 2]

  """
  @spec lift(Apply.t(), Apply.t(), Apply.t(), fun()) :: Apply.t()
  def lift(a, b, c, fun) do
    a
    |> lift(fun)
    |> reverse_ap(b)
    |> reverse_ap(c)
  end

  @doc """
  Extends `lift` to apply arguments to a quaternary function

  ## Examples

      iex> lift([1, 2], [3, 4], [5, 6], [7, 8], fn(a, b, c, d) -> a * b - c + d end)
      [5, 6, 4, 5, 6, 7, 5, 6, 8, 9, 7, 8, 10, 11, 9, 10]

  """
  @spec lift(Apply.t(), Apply.t(), Apply.t(), Apply.t(), fun()) :: Apply.t()
  def lift(a, b, c, d, fun), do: a |> lift(b, c, fun) |> reverse_ap(d)
end

definst Witchcraft.Apply, for: Function do
  use Quark
  def ap(g, f), do: fn x -> curry(f).(x).(curry(g).(x)) end
end

definst Witchcraft.Apply, for: List do
  @force_type_instance true

  def ap(val_list, fun_list) when is_list(fun_list) do
    Enum.flat_map(fun_list, fn(fun) ->
      Enum.map(val_list, fun)
    end)
  end
end

# Contents must be semigroups
definst Witchcraft.Apply, for: Tuple do
  import TypeClass.Property.Generator, only: [generate: 1]
  use Witchcraft.Semigroup

  custom_generator(_) do
    {generate(""), generate(1), generate(0), generate(""), generate(""), generate("")}
  end

  def ap({v, w},          {a,          fun}), do: {a <> v, fun.(w)}
  def ap({v, w, x},       {a, b,       fun}), do: {a <> v, b <> w, fun.(x)}
  def ap({v, w, x, y},    {a, b, c,    fun}), do: {a <> v, b <> w, c <> x, fun.(y)}
  def ap({v, w, x, y, z}, {a, b, c, d, fun}) do
    {
      a <> v,
      b <> w,
      c <> x,
      d <> y,
      fun.(z)
    }
  end

  def ap(tuple_b, tuple_a) when tuple_size(tuple_a) == tuple_size(tuple_b) do
    last_index = tuple_size(tuple_a) - 1

    tuple_a
    |> Tuple.to_list()
    |> Enum.zip(Tuple.to_list(tuple_b))
    |> Enum.with_index()
    |> Enum.map(fn
      {{fun,  arg},   ^last_index} -> fun.(arg)
      {{left, right}, _}           -> left <> right
    end)
    |> List.to_tuple()
  end
end
