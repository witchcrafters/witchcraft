defmodule Witchcraft.Applicative.Function do
  @moduledoc ~S"""
  Function helpers, derivatives and operators for `Witchcraft.Applicative`
  """

  import Kernel, except: [apply: 2]

  import Quark, only: [flip: 1]
  import Quark.Curry, only: [curry: 1]

  import Witchcraft.Applicative, only: [apply: 2]
  import Witchcraft.Functor.Operator, only: [<~: 2, ~>: 2]

  defmacro __using__(_) do
    quote do
      import Kernel, except: [apply: 2]
      import Witchcraft.Applicative.Function, only: [lift: 2]
    end
  end


  # liftA*
  @doc ~S"""
  `lift` a function that takes a list of arguments

  ```elixir

  iex> lift([1,2,3], [4,5,6], &(&1 + &2))
  [5,6,7,6,7,8,7,8,9]

  iex> lift([1,2], [3,4], [5,6], &(&1 + &2 + &3))
  [9,10,10,11,10,11,11,12]

  iex> lift([1,2], [3,4], [5,6], [7,8], &(&1 + &2 + &3 + &4))
  [16,17,17,18,17,18,18,19,17,18,18,19,18,19,19,20]

  ```

  """
  @spec lift([any], (... -> any)) :: any
  def lift([value], func), do: value <~ func

  def lift([head|tail], func) do
    lifted = curry(func) ~> head
    Enum.reduce(tail, lifted, flip(&apply/2))
  end

  defdelegate lift(functor_value, bare_function), to: Witchcraft.Functor
end
