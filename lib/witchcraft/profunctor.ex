# use TypeClass

# defclass Witchcraft.Profunctor do
#   where do
#     def promap(wrapped, f, g)
#   end

#   properties do
#     def identity(data) do
#       import Quark
#       a = generate(data)
#       promap(a, &id/1, &id/1) == a
#     end

#     def composition(data) do
#       a = generate(data)
#       promap()
#       left  = a |> promap(fn a -> f.(g.(a)) end, fn b -> h.(i.(b)) end)
#       right = a |> promap(f, i) |> promap(g, h)

#       left == right
#     end
#   end
# end

# definst Witchcraft.Profunctor do
#   # So confused right now
#   def promap({b, c}, b_to_a, c_to_d), do: {b_to_a.(b), c_to_d.(c)}
# end
