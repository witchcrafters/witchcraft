defprotocol Witchcraft.Monad do

  @spec return(any) :: any
  def return(bare)

  @spec bind(any, (any -> any)) :: any
  def bind(wrapped_element, wrapping_func)

  @spec then(any, any) :: any
  def then(wrapped_element, wrapped_element)
end
