# use TypeClass

# defclass Witchcraft.Foldable do
#   where do
#     @doc "reducer must be a binary function"
#     def foldr(foldable, seed, reducer)
#   end

#   # People are working on Foldable properties
#   # The best answer so far is abstract and strongly typed
#   # Ex. https://mail.haskell.org/pipermail/libraries/2015-February/024943.html
#   properties, do: nil
# end

# definst Witchcraft.Foldable, for: List do
#   def foldr(list, seed, reducer), do: Enum.reduce(list, seed, reducer)
# end

# definst Witchcraft.Foldable, for: Map do
#   def foldr(map, seed, reducer), do: Enum.reduce(map, seed, reducer)
# end
