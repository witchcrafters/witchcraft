defprotocol Witchcraft.Applicative.Protocol do

  @type applicative :: any

  @doc ~S"""
  Lift a pure value into a type provided by some specemin (usually the zeroth
  or empty value of that type, but not nessesarily).
  """
  @spec wrap(any, any) :: any
  def wrap(specimen, bare)

  @doc ~S"""
  Sequentially seq lifted function(s) to lifted data.
  """
  @spec seq(applicative, fun) :: any
  def seq(wrapped_value, wrapped_function)
end

defimpl Witchcraft.Applicative.Protocol, for: Any do
  @doc ~S"""
  By default, use the true identity functor (ie: don't wrap)
  """
  def wrap(_, bare_value), do: bare_value

  @doc ~S"""
  For un`wrap`ped values, treat `seq` as plain function application.
  """
  def seq(bare_value, bare_function), do: Quark.Curry.curry(bare_function).(bare_value)
end

defimpl Witchcraft.Applicative.Protocol, for: List do
  import Quark.Curry, only: [curry: 1]

  @doc ~S"""

  ## Examples

      iex> wrap([], 0)
      [0]

  """
  def wrap(_, bare), do: [bare]

  @doc ~S"""

  ## Examples

      iex> seq([1,2,3], [&(&1 + 1), &(&1 * 10)])
      [2,3,4,10,20,30]

      iex> import Witchcraft.Functor, only: [lift: 2]
      iex> seq([9,10,11], lift([1,2,3], &(fn x -> x * &1 end)))
      [9,10,11,18,20,22,27,30,33]

  """
  def seq(_, []), do: []
  def seq(values, [fun|funs]) do
    Enum.map(values, curry(fun)) ++ Witchcraft.Applicative.seq(values, funs)
  end
end
