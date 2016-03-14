defmodule Witchcraft.Arrow.Kleisli do
  use Quark.Partial

  @type t :: %Kleisli{binder: (any -> any)}
  defstruct [:binder]

  defpartial kleisli(a), do: %Witchcraft.Arrow.Kleisli(binder: a)
end
