# import TypeClass

# defclass Witchcraft.Chainable.Fixed do
#   extend Witchcraft.Chainable

#   where do
#     def fixed_chain(start, fix)
#   end

#   properties do
#     def purity(data) do
#       a = generate(data)
#       h = fn -> nil end

#       left  = Fixed.fixed_chain(fn x -> x |> h |> pure end).(a)
#       right = pure(fix(h)).(a)
#     end


#     # left shrinking (or tightening)
#     # mfix (\x -> a >>= \y -> f x y) = a >>= \y -> mfix (\x -> f x y)

#     # sliding
#     # mfix (liftM h . f) = liftM h (mfix (f . h)), for strict h.

#     # nesting
#     # mfix (\x -> mfix (\y -> f x y)) = mfix (\x -> f x x)
#   end
# end

# definst Witchcraft.Chainable.Fixed, for: List do
#   def fixed_chain(list, fixed_fun) do
#     tail = fn [_ | as] -> as end
#     case fix.(fixed_fun <|> List.first).(list) do
#       [] -> []

#       [a | _] ->
#         new_tail = fixed_chain(fn x -> x |> fixed_fun.() |> tail.() end).(list)
#         [a | new_tail]
#     end
#   end
# end
