defprotocol Witchcraft.Arrow do
  @type arrow(a, b, c) :: {a, b, c}
  @type split(b, c) :: {b, c}

  @spec arr((any -> any)) :: arrow(any, any, any)
  def arr(b_to_c)

  @spec first(arrow(any, any, any)) :: arrow(any, any, any)
  def first(arrow)

  @spec second(arrow(any, any, any)) :: arrow(any, any, any)
  def second(arrow)
end
