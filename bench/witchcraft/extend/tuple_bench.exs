defmodule Witchcraft.Extend.TupleBench do
  @moduledoc false

  use Benchfella
  use Witchcraft.Extend

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @tuple {777, 42}

  ##########
  # Extend #
  ##########

  bench("nest/1", do: nest(@tuple))

  bench("extend/2", do: extend(@tuple, fn t -> elem(t, 0) + 1 end))
  bench("curried_extend/2", do: curried_extend(@tuple, fn t -> elem(t, 0) + 1 end))

  bench("peel/2", do: peel(fn t -> elem(t, 0) + 1 end, @tuple))
  bench("curried_peel/2", do: curried_peel(fn t -> elem(t, 0) + 1 end, @tuple))

  bench("compose_colink/2",
    do: compose_colink(fn t -> elem(t, 0) + 1 end, fn t -> elem(t, 1) * 10 end)
  )

  bench("pipe_compose_colink/2",
    do: pipe_compose_colink(fn t -> elem(t, 0) * 10 end, fn t -> elem(t, 2) + 1 end)
  )

  bench "apply compose_colink/2" do
    both = compose_colink(fn t -> elem(t, 0) + 1 end, fn t -> elem(t, 1) * 10 end)
    extend(@tuple, both)
  end

  bench "apply pipe_compose_colink/2" do
    both = pipe_compose_colink(fn t -> elem(t, 1) * 10 end, fn t -> elem(t, 0) + 1 end)
    extend(@tuple, both)
  end
end
