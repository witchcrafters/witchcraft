defclass Witchcraft.Apply do
  extend Witchcraft.Functor

  where do
    def ap(wrapped_fun, wrapped)
  end

  properties do
    def composition(data) do
      a = generate(data)
      b = Semigroup.concat(&inspect/1, Monoid.empty(a))
      c = Semigroup.concat(&String.first/1, Monoid.empty(a))

      left =
        b |> Apply.ap(
          c|> Apply.ap(
            a |> Witchcraft.Functor.lift(
              fn f ->
                fn g ->
                  fn x ->
                    f.(g.(x))
                  end
                end
              end
            )
          )
        )

      right = b |> ap(c) |> ap(a)

      left == right
    end
  end
end

definst Witchcraft.Apply, for: List do
  def ap(fun_list, list) do
    Witchcraft.Foldable.fold(list, [], fn(item, acc) ->
      acc ++ Witchcraft.Functor.map(fun_list, fn fun -> fun.(item) end)
    end)
  end
end

definst Witchcraft.Apply, for: Tuple do
  def ap(fun_tuple, arg_tuple) do
    fun_list = Tuple.to_list(fun_tuple)
    arg_list = Tuple.to_list(arg_tuple)

    Witchcraft.Apply.ap(fun_list, arg_list)
  end
end
