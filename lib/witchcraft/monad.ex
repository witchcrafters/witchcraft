defprotocol Witchcraft.Monad do
  @moduledoc ~S"""
  Because we are following the `Functor -> Applicative -> Monad` hierarchy,
  `return` is already defined as `pure`. `bind` can be defined in terms of `join`
  and `lift`, so we only need to define `join` for monads.
  """

  @fallback_to_any true

  @doc ~S"""
  `join` takes a recursively nested data structure, and joins the two outermost
  levels together to result in one level. This may be seen as a "flattening"
  operation for most datatypes.

  ```iex

  iex> Witchcraft.Monad.join([[[1,2,3]]])
  [[1,2,3]]

  ```

  """
  @spec join(any) :: any
  def join(deep)
end

# Algae.Maybe
# ===========

defimpl Witchcraft.Monad, for: Algae.Maybe.Nothing do
  def join(%Algae.Maybe.Nothing{}), do: %Algae.Maybe.Nothing{}
end

defimpl Witchcraft.Monad, for: Algae.Maybe.Just do
  def join(%Algae.Maybe.Just{just: %Algae.Maybe.Nothing{}}), do: %Algae.Maybe.Nothing{}
  def join(%Algae.Maybe.Just{just: %Algae.Maybe.Just{just: value}}) do
    %Algae.Maybe.Just{just: value}
  end
end

# Algae.Either
# ============

defimpl Witchcraft.Monad, for: Algae.Either.Left do
  def join(%Algae.Either.Left{left: value}), do: %Algae.Either.Left{left: value}
end

defimpl Witchcraft.Monad, for: Algae.Either.Right do
  def join(%Algae.Either.Right{right: %Algae.Either.Left{left: value}}) do
    %Algae.Either.Left{left: value}
  end

  def join(%Algae.Either.Right{right: %Algae.Either.Right{right: value}}) do
    %Algae.Either.Right{right: value}
  end
end

# Algae.Free
# ==========

defimpl Witchcraft.Monad, for: Algae.Free.Shallow do
  def join(shallow), do: shallow
end

defimpl Witchcraft.Monad, for: Algae.Free.Deep do
  def join(deep), do: deep
end
