defprotocol Witchcraft.Monad do
  @moduledoc ~S"""
    Expects that you have implimented `Witchcraft.Functor` and `Witchcraft.Applicative`
    for the datatype that you wish to use with `Wicthcraft.Monad`. All sensible
    monads are also functors and applicatives.
  """

  @spec return(a) :: any
  def return(bare)

  @spec join(a) :: a
  def join(a)

  # @spec bind(any, (any -> any)) :: any
  # def bind(wrapped_element, wrapping_func)

  # @spec then(any, any) :: any
  # def then(wrapped_element, wrapped_element)
end

defimpl Witchcraft.Monad, for: Witchcraft.ADT.Maybe do
    def return(data), do: %ADT.Maybe{maybe: data}

    def join(%ADT.Maybe{maybe: %ADT.Maybe{maybe: data}}), do: %ADT.Maybe{maybe: data}
    def join(maybe_data), do: maybe_data
end

defimpl Witchcraft.Monad, for: Witchcraft.ADT.MaybePlus do
  def return(data), do: %ADT.MaybePlus{maybe: data}

  def join(%ADT.Maybe{maybe: %ADT.Maybe{maybe: data, meta: meta}, meta: _}) do
    %ADT.Maybe{maybe: data, meta: meta}
  end

  def join(maybe_data), do: maybe_data
end
