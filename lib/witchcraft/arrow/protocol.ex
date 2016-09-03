defprotocol Witchcraft.Arrow do
  @moduledoc ~S"""
  """

  @fallback_to_any true

  @doc ~S"""
  """
  @spec arrow((... -> any)) -> (any -> any)
  def arrow(fun)

  @doc ~S"""
  """
  @spec first() :: any
  def first()

  @doc ~S"""
  """
  @spec second() :: any
  def second()

  @doc ~S"""
  """
  @spec parallel_compose() :: any
  def parallel_compose()

  @doc ~S"""
  """
  @spec fanout_compose() :: any
  def fanout_compose()
end
