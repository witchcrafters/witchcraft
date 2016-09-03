defmodule Witchcraft.Arrow do

  defdelegate arrow(fun), to: Witchcraft.Arrow.Protocol
  defdelegate first(fun), to: Witchcraft.Arrow.Protocol
  defdelegate second(fun), to: Witchcraft.Arrow.Protocol
  defdelegate parallel_compose(fun), to: Witchcraft.Arrow.Protocol
  defdelegate fanout_compose(fun), to: Witchcraft.Arrow.Protocol
end
