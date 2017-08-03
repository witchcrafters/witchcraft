defmodule Witchcraft.FunctorBench do
  alias Witchcraft.Functor
  use Witchcraft.Functor

  use Benchfella

  #########
  # Setup #
  #########

  # ---------- #
  # Data Types #
  # ---------- #

  @list  Enum.to_list(0..10_000)
  @tuple List.to_tuple(@list)
  @map   @list |> Enum.zip(@list) |> Enum.into(%{})

  def fun(x), do:  "#{inspect x}-#{inspect x}"

  # -------------- #
  # Test Functions #
  # -------------- #

  defp square(x), do: x * x
  defp twice(f),  do: fn x -> x |> f.() |> f.() end

  ########
  # Enum #
  ########

  bench "[]  Enum.map/2", do: Enum.map(@list, &square/1)
  bench "{}  Enum.map/2", do: @tuple |> Enum.to_list() |> Enum.map(&square/1) |> List.to_tuple()
  bench "%{} Enum.map/2", do: @map |> Enum.map(&square/1) |> Enum.into(%{})
  bench "fn  manual compose", do: fn x -> x |> fun() |> twice() end

  ##############
  # Witchcraft #
  ##############

  # ====== #
  # Static #
  # ====== #

  bench "[]  map/2", do: Functor.map(@list,  &square/1)
  bench "{}  map/2", do: Functor.map(@tuple, &square/1)
  bench "%{} map/2", do: Functor.map(@map,   &square/1)
  bench "fn  map/2", do: Functor.map(&fun/1, &twice/1)

  bench "[]  across/2", do: Functor.across(&square/1, @list)
  bench "{}  across/2", do: Functor.across(&square/1, @tuple)
  bench "%{} across/2", do: Functor.across(&square/1, @map)
  bench "fn  across/2", do: Functor.across(&twice/1,  &fun/1)

  bench "[]  replace/2", do: Functor.replace(@list,  42)
  bench "{}  replace/2", do: Functor.replace(@tuple, 42)
  bench "%{} replace/2", do: Functor.replace(@map,   42)
  bench "fn  replace/2", do: Functor.replace(&fun/1, &twice/1)

  # ----- #
  # Async #
  # ----- #

  bench "[]  async_map/2",    do: async_map(@list,  &square/1)
  bench "{}  async_map/2",    do: async_map(@tuple, &square/1)
  bench "%{} async_map/2",    do: async_map(@map,   &square/1)
  bench "fn  async_map/2",    do: async_map(&fun/1, &twice/1)

  bench "[]  async_across/2", do: async_across(&square/1, @list)
  bench "{}  async_across/2", do: async_across(&square/1, @tuple)
  bench "%{} async_across/2", do: async_across(&square/1, @map)
  bench "fn  async_across/2", do: async_across(&twice/1,  &fun/1)

  # ======= #
  # Curried #
  # ======= #

  bench "[]  lift/2", do: lift(@list,  &square/1)
  bench "{}  lift/2", do: lift(@tuple, &square/1)
  bench "%{} lift/2", do: lift(@map,   &square/1)
  bench "fn  lift/2", do: lift(&fun/1, &twice/1)

  bench "[]  over/2", do: over(&square/1, @list)
  bench "{}  over/2", do: over(&square/1, @tuple)
  bench "%{} over/2", do: over(&square/1, @map)
  bench "fn  over/2", do: over(&twice/1,  &fun/1)

  # ------------- #
  # Async Curried #
  # ------------- #

  bench "[]  async_lift/2", do: async_lift(@list,  &square/1)
  bench "{}  async_lift/2", do: async_lift(@tuple, &square/1)
  bench "%{} async_lift/2", do: async_lift(@map,   &square/1)
  bench "fn  async_lift/2", do: async_lift(&fun/1, &twice/1)

  bench "[]  async_over/2", do: async_over(&square/1, @list)
  bench "{}  async_over/2", do: async_over(&square/1, @tuple)
  bench "%{} async_over/2", do: async_over(&square/1, @map)
  bench "fn  async_over/2", do: async_over(&twice/1,  &fun/1)

  # --------- #
  # Operators #
  # --------- #

  bench "[]  ~>/2", do: @list    ~> (&square/1)
  bench "{}  ~>/2", do: @tuple   ~> (&square/1)
  bench "%{} ~>/2", do: @map     ~> (&square/1)
  bench "fn  ~>/2", do: (&fun/1) ~> (&twice/1)

  bench "[]  <~/2", do: (&square/1) <~ @list
  bench "{}  <~/2", do: (&square/1) <~ @tuple
  bench "%{} <~/2", do: (&square/1) <~ @map
  bench "fn  <~/2", do: (&twice/1)  <~ (&fun/1)
end
