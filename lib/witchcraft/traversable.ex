# use TypeClass

# defclass Witchcraft.Traversable do
#   extend Witchcraft.Foldable
#   extend Witchcraft.Functor

#   where do
#     def traverse(traversable, wrap_map)
#   end

#   properties do
#     # u.traverse(F.of, F.of) is equivalent to F.of(u) for any Applicative F (identity)
#     # traverse Identity = Identity -- identity
#     def identity(data) do
#       a = generate(data)

#     end

#     # u.traverse(x => new Compose(x), Compose.of) is equivalent to new Compose(u.traverse(x => x, F.of).map(x => x.traverse(x => x, G.of))) for Compose defined below and any Applicatives F and G (composition)
#     # traverse (Compose . fmap g . f) = Compose . fmap (traverse g) . traverse f -- composition
#     def composition(data) do
#       a = generate(data)
#     end
#   end
# end

# definst Witchcraft.Functor, for: List do
#   def traverse(list, fun) do
#     list
#     |> Witchcraft.Traversable.foldr([], fn [x | ys], acc ->
#       ys
#       |> Witchcraft.Apply.ap(fun.(x))
#       |> Enum.concat
#     end)
#   end
# end
