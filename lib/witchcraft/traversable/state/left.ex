import TypeClass

defmodule Witchcraft.Traversable.State.Left do
  @moduledoc "Left-to-right state transformer"

  alias Witchcraft.Traversable.State

  defstruct run: &State.Left.run/1

  def run(x), do: {_value = x, _state = x}

  def new(), do: %State.Left{}
  def new(run_function), do: %State.Left{run: run_function}
end

defimpl TypeClass.Property.Generator, for: Witchcraft.Traversable.State.Left do
  def generate(_), do: %Witchcraft.Traversable.State.Left{}
end

definst Witchcraft.Functor, for: Witchcraft.Traversable.State.Left do
  alias Witchcraft.Traversable.State

  def map(state = %State.Left{run: runner}, fun) do
    State.Left.new fn s ->
      {intermediate_value, new_state} = runner.(s)
      {fun.(intermediate_value), new_state}
    end
  end
end

definst Witchcraft.Apply, for: Witchcraft.Traversable.State.Left do
  alias Witchcraft.Traversable.State

  def ap(%State.Left{run: runner_fun}, %State.Left{run: runner_arg}) do
    Witchcraft.Traversable.State.Left.new fn initial_state ->
      {intermediate_state, extracted_fun     } = initial_state |> runner_fun
      {final_state,        intermediate_value} = intermediate_state |> runner_arg

      {final_state, intermediate_value |> extracted_fun}
    end
  end
end

definst Witchcraft.Applicative, for: Witchcraft.Traversable.State.Left do
  def of(_, value) do
    %Witchcraft.Traversable.State.Left{run: fn state -> {value, state} end}
  end
end
