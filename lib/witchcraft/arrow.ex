defprotocol Witchcraft.Arrow do
  @type a :: any
  @type b :: any
  @type c :: any

  @type a_to_b :: (a -> b)
  @type b_to_c :: (b -> c)

  @type arrow(a, a_to_b, b_to_c) :: {a, a_to_b, b_to_c}
  @type split(a_to_b, b_to_c)    :: {a_to_b, b_to_c}

  @spec arr(b_to_c) :: arrow(a, a_to_b, b_to_c)
  def arr(b_to_c)

  @spec first(arrow(a, a_to_b, b_to_c)) :: arrow(a, a_to_b, b_to_c)
  def first(arrow)

  @spec second(arrow(a, a_to_b, b_to_c)) :: arrow(a, a_to_b, b_to_c)
  def second(arrow)
end
