defmodule Witchcraft.Traversable.State.Left do
  @moduledoc "Left-to-right state transformer"

  defstruct run: fn x -> {_value = x, _state = x} end

  alias Witchcraft.Traversable.State

  def new(run_function), do: %State.Left{run: run_function}
end

definst Witchcraft.Functor, for: Witchcraft.Traversable.State.Left do
  def map(state = %State.Left{run: runner}, fun) do
    State.Left.new fn s ->
      {intermediate_value, new_state} = s |> runner
      {intermediate_value |> fun, new_state}
    end
  end
end

definst Witchcraft.Apply, for: Witchcraft.Traversable.State.Left do
  def ap(%State.Left{run: runner_fun}, %State.Left{run: runner_arg}) do
    State.Left.new fn initial_state ->
      {intermediate_state, extracted_fun     } = initial_state |> runner_fun
      {final_state,        intermediate_value} = intermediate_state |> runner_arg

      {final_state, intermediate_value |> extracted_fun}
    end
  end
end

definst Witchcraft.Applicative, for: Witchcraft.Traversable.State.Left do
  def of(_, value), do: %State.Left{run: fn state -> (value, state) end}
end
