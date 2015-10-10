defprotocol Witchcraft.Arrow do
  @type arrow :: {any, any, any}
  @type split :: {any, any}

  @spec arr((any -> any)) :: arrow
  def arr(b->c)

  @spec first(arrow) :: arrow
  def first(arrow)

  @spec second(arrow) :: arrow
  def second(arrow)
end
