defmodule Witchcraft.Functor.Functions do
  alias Witchcraft.Functor, as: F
  alias Witchcraft.Utility, as: U

  @doc ~S"""
  Replace all of the input's data nodes with some constant value

  # Example
  ```

  iex> Witchcraft.Functor.Functions.map_replace([1,2,3], 42)
  [42, 42, 42]

  ```
  """
  @spec map_replace(any, any) :: any
  def map_replace(a, constant) do
    F.lift(a, &(U.constant(&1, constant)))
  end

  @doc ~S"""
  Alias for `lift` with arguments flipped ('map over')

  # Example

  ```

  iex> (&(&1 * 10)) <~ [1,2,3]
  [10, 20, 30]

  ```

  """
  @spec (any -> any) <~ any :: any
  def func <~ args, do: F.lift(args, func)

  @doc ~S"""
  Alias for `lift`

  # Example

  ```

  iex> [1,2,3] ~> &(&1 * 10)
  [10, 20, 30]

  ```

  """
  @spec any ~> (any -> any) :: any
  def args ~> func, do: func <~ args
end
