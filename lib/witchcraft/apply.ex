import TypeClass

defclass Witchcraft.Apply do
  extend Witchcraft.Functor

  import Witchcraft.Functor

  defmacro __using__(_) do
    quote do
      import Witchcraft.Functor
      import unquote(__MODULE__)
    end
  end

  where do
    def ap(wrapped_funs, wrapped)
  end

  def reverse_ap(wrapped, wrapped_funs), do: ap(wrapped_funs, wrapped)

  defalias wrapped_funs <<~ wrapped, as: :ap
  defalias wrapped ~>> wrapped_funs, as: :reverse_ap

  def lift(a, fun, b), do: fun <~ a <<~ b
  def lift(a, fun, b, c), do: fun <~ a <<~ b <<~ c
  def lift(a, fun, b, c, d), do: fun <~ a <<~ b <<~ c <<~ d
  def lift(a, fun, b, c, d, e), do: fun <~ a <<~ b <<~ c <<~ d <<~ e
  def lift(a, fun, b, c, d, e, f), do: fun <~ a <<~ b <<~ c <<~ d <<~ e <<~ f
  def lift(a, fun, b, c, d, e, f, g), do: fun <~ a <<~ b <<~ c <<~ d <<~ e <<~ f <<~ g
  def lift(a, fun, b, c, d, e, f, g, h), do: fun <~ a <<~ b <<~ c <<~ d <<~ e <<~ f <<~ g <<~ h
  def lift(a, fun, b, c, d, e, f, g, h, i), do: fun <~ a <<~ b <<~ c <<~ d <<~ e <<~ f <<~ g <<~ h <<~ i

  properties do
    def composition(data) do
      alias Witchcraft.Functor

      # Force strings
      as = data |> generate |> Functor.lift(&inspect/1)

      fs = data |> generate |> Functor.lift(fn x -> fn y -> inspect(y) <> "foo" <> x end end)
      gs = data |> generate |> Functor.lift(fn x -> fn y -> x <> "bar" <> inspect(y) end end)
      hs = data |> generate |> Functor.lift(fn x -> fn y -> x <> inspect(y) <> "baz" end end)
      comps = data |> generate |> Functor.replace(&Quark.compose/2)

      left  = fs    |> Apply.ap(as) |> Apply.ap(gs) |> Apply.ap(hs)
      right = comps |> Apply.ap(hs) |> Apply.ap(gs) |> Apply.ap(as)

      left == right
    end
  end
end

# definst Witchcraft.Apply, for: Any do
#   def ap(f, g) when is_function(f), do: fn x -> f.(x).(g.(x)) end
# end

# definst Witchcraft.Apply, for: List do
#   def ap(fun_list, list) do
#     Witchcraft.Foldable.fold(list, [], fn(item, acc) ->
#       acc ++ Witchcraft.Functor.map(fun_list, fn fun -> fun.(item) end)
#     end)
#   end
# end

# definst Witchcraft.Apply, for: Tuple do
#   def ap(fun_tuple, arg_tuple) do
#     fun_list = Tuple.to_list(fun_tuple)
#     arg_list = Tuple.to_list(arg_tuple)

#     Witchcraft.Apply.ap(fun_list, arg_list)
#   end
# end
