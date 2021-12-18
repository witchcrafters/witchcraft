defmodule Witchcraft.Arrow.FunctionBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Arrow

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @single "data"
  @tuple {32, "1955?!"}

  defp f(x), do: "#{inspect x}/#{inspect x}"
  defp g(y), do: "#{inspect y}-#{inspect y}-#{inspect y}"

  #########
  # Arrow #
  #########

  bench "arrowize/2", do: arrowize(&f/1, &g/1)
  bench "id_arrow/1", do: id_arrow(&+/2)

  bench "precompose/2",  do: precompose(&g/1, &f/1)
  bench "postcompose/2", do: postcompose(&f/1, &g/1)

  bench "first/1",  do: first(&f/1)
  bench "second/1", do: second(&f/1)

  bench "apply first/1",  do: first(&f/1).(@tuple)
  bench "apply second/1", do: second(&f/1).(@tuple)

  bench "product/2", do: product(&f/1, &g/1)
  bench "fanout/2",  do: fanout(&f/1, &g/1)

  bench "apply product/2", do: product(&f/1, &g/1).(@tuple)
  bench "apply fanout/2",  do: fanout(&f/1, &g/1).(@single)

  # ---------------- #
  # Tuple Operations #
  # ---------------- #

  bench "swap/1",    do: swap({1, 2})

  bench "split/1",   do: split(42)
  bench "unsplit/1", do: unsplit({42, 42}, &+/2)

  bench "left reassociate/1",  do: ({1, {2, 3}})
  bench "right reassociate/1", do: ({{1, 2}, 3})

end
