defmodule Witchcraft.Functor.Property do
  @moduledoc ~S"""
  Check samples of your functor to confirm that your data adheres to the
  functor properties. *All members* of your datatype should adhere to these rules.
  They are placed here as a quick way to check some of your values.
  """

  import Quark, only: [compose: 1, id: 1]
  import Witchcraft.Functor, only: [lift: 2]

  @doc ~S"""
  Check all functor properties

  ```elixir

  iex> alias Algae.Id, as: Id
  iex> defmodule Typecheck do
  ...>   def is_id(%Id{id: _}), do: true
  ...>   def is_id(_), do: false
  ...> end
  iex> check(%Id{id: 42}, &(&1 + 1), &(&1 * 2), &Typecheck.is_id/1)
  true

  ```

  """
  @spec functor(any, (any -> any), (any -> any), (any -> boolean)) :: boolean
  def functor(context, f, g, typecheck) do
    associates_object(context, f, typecheck)
      and preserve_identity(context, f)
      and preserve_compositon(context, f, g)
  end

  @doc ~S"""
  Check that lifting a function into some context returns a member of the target type

  ```elixir

  iex> alias Algae.Id, as: Id
  iex> defmodule Typecheck do
  ...>   def is_id(%Id{id: _}), do: true
  ...>   def is_id(_), do: false
  ...> end
  iex> associates_object(%Id{id: 42}, &Quark.id/1, &Typecheck.is_id/1)
  true

  ```

  """
  @spec associates_object(any, (any -> any), (any -> boolean)) :: boolean
  def associates_object(context, func, typecheck) do
    lift(context, func) |> typecheck.()
  end

  @doc ~S"""
  Check that lifting a function does not interfere with identity.
  In other words, lifting `id(a)` shoud be the same as the identity of lifting `a`.

       A ---- id ----> A

       |               |
      (f)             (f)
       |               |
       v               v

       B ---- id ----> B


  ```elixir

  iex> preserve_identity(%Algae.Id{id: 7}, &(&1 + 1))
  true

  ```

  """
  @spec preserve_identity(any, (any -> any)) :: boolean
  def preserve_identity(context, func) do
    lift(id(context), func) == id(lift(context, func))
  end

  @doc ~S"""
  Check that lifting a composed function is the same as lifting functions in sequence

  ```elixir

  iex> preserve_compositon(%Algae.Id{id: 5}, &(&1 + 1), &(&1 * 10))
  true

  ```

  """
  @spec preserve_compositon(any, (any -> any), (any -> any)) :: boolean
  def preserve_compositon(context, f, g) do
    lift(lift(context, f), g) == lift(context, compose([g, f]))
  end
end
