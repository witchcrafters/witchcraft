defprotocol Witchcraft.Monad do
  @moduledoc ~S"""
  Because we are following Functor/Applicative/Monad superclassing, `return` is `pure`,
  so no need to define `return`. `bind` can be defined in terms of `join` and `lift`.
  """

  @fallback_to_any true

  @doc ~S"""
  """
  @spec join(any) :: any
  def join(deep)
end

# Algae.Id
# ===========

defimpl Witchcraft.Monad, for: Algae.Id do
  def join(%Algae.Id{id: %Algae.Id{id: value}}), do: %Algae.Id{id: value}
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
# ===========

defimpl Witchcraft.Monad, for: Algae.Either.Left do
  def join(%Algae.Either.Left{left: value}), do: %Algae.Maybe.Left{left: value}
end

defimpl Witchcraft.Monad, for: Algae.Either.Right do
  def join(%Algae.Either.Right{right: %Algae.Either.Left{left: value}}) do
    %Algae.Either.Left{left: value}
  end

  def join(%Algae.Either.Right{right: %Algae.Either.Right{right: value}}) do
    %Algae.Either.Right{right: value}
  end
end
