defmodule Witchcraft.UnitBench do
  @moduledoc false

  use Benchfella
  import Witchcraft.Unit

  bench "new/0",    do: new()
  bench "struct/1", do: struct(Witchcraft.Unit)
  bench "%Unit{}",  do: %Witchcraft.Unit{}
end
