import TypeClass

defclass Witchcraft.Monad do
  @moduledoc """
  Very similar to `Chain`, `Monad` provides a way to link actions, and a way
  to bring plain values into the correct context (`Applicative`).

  This allows us to view actions in a full framework along the lines of
  functor and applicative:

                 data ---------------- function ----------------------------> result
                   |                      |                                     |
       of(Container, data)          of/2, or similar                of(Container, result)
                   ↓                      ↓                                     ↓
      %Container<data> --- (data -> %Container<updated_data>) ---> %Container<updated_data>

  As you can see, the linking function may just be `of` now that we have that.

  For a nice, illustrated introduction,
  see [Functors, Applicatives, And Monads In Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html).

  Having `of` also lets us enhance do-notation with a convenuenct `return` function (see `monad/2`)

  ## Type Class

  An instance of `Witchcraft.Monad` must also implement `Witchcraft.Applicative`
  and `Wicthcraft.Chainable`.

                       Functor     [map/2]
                          ↓
                        Apply      [ap/2]
                        ↓   ↓
      [of/2]  Applicative   Chain  [chain/2]
                        ↓   ↓
                        Monad
                         [_]
  """

  extend Witchcraft.Applicative
  extend Witchcraft.Chain

  alias Witchcraft.Monad.AST
  import Witchcraft.Chain

  defmacro __using__(opts \\ []) do
    quote do
      use Witchcraft.Applicative, unquote(opts)
      use Witchcraft.Chain,       unquote(opts)
      import unquote(__MODULE__), unquote(opts)
    end
  end

  @doc ~S"""
  do-notation enhanced with a `return` operation.

  `return` is the simplest possible linking function, providing the correct `of/2`
  instance for your monad.

  ## Examples

      iex> monad [] do
      ...>   [1, 2, 3]
      ...> end
      [1, 2, 3]

      iex> monad [] do
      ...>   [1, 2, 3]
      ...>   [4, 5, 6]
      ...>   [7, 8, 9]
      ...> end
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

      iex> monad [] do
      ...>   Witchcraft.Applicative.of([], 1)
      ...> end
      [1]

      iex> monad [] do
      ...>  a <- [1,2,3]
      ...>  b <- [4,5,6]
      ...>  return(a * b)
      ...> end
      [
        4, 8,  12,
        5, 10, 15,
        6, 12, 18
      ]

      iex> monad [] do
      ...>   a <- return 1
      ...>   b <- return 2
      ...>   return(a + b)
      ...> end
      [3]

  """
  defmacro monad(sample, do: input) do
    preprocessed = AST.preprocess(input, sample)
    quote do: Witchcraft.Chain.chain(do: unquote(preprocessed))
  end

  properties do
    import Witchcraft.Applicative
    import Witchcraft.Chain

    def left_identity(data) do
      a = generate(data)
      f = &Witchcraft.Functor.replace(a, inspect(&1))

      left  = a |> of(a) |> chain(f)
      right = f.(a)

      equal?(left, right)
    end

    def right_identity(data) do
      a = generate(data)
      left = a >>> &of(a, &1)

      equal?(a, left)
    end
  end
end

definst Witchcraft.Monad, for: Function
definst Witchcraft.Monad, for: List

definst Witchcraft.Monad, for: Tuple do
  use Witchcraft.Semigroup
  import TypeClass.Property.Generator, only: [generate: 1]

  custom_generator(_) do
    {generate(""), generate("")}
  end
end
