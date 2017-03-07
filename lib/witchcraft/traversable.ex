# import TypeClass

# defclass Witchcraft.Traversable do
#   extend Witchcraft.Foldable
#   extend Witchcraft.Functor

#   defmacro __using__(_) do
#     quote do
#       import Witchcraft.Functor
#       use Witchcraft.Foldable

#       import unquote(__MODULE__)
#     end
#   end

#   where do
#     def traverse(traversable, mapping_fun)
#   end

#   properties do
#     def naturality(data) do
#       a = generate(data)
#       left  = a |> &Traversable.traverse(f) |> t()
#       right = a |> Traversable.traverse(t <|> f)

#       equal?(left, right)
#     end

#     def identity(data) do
#       a = generate(data)
#       Traversable.traverse(a, &Algae.Id.new/1) == Algae.Id.new(a)
#     end

#     def composition(data) do
#       traverse (Compose . fmap g . f) = Compose . fmap (traverse g) . traverse f

#       a = generate(data)
#       inner = Algae.Compose.new <|> &Functor.lift(g) <|> &f/1

#       Traversable.traverse(a, inner) == inner.(a)
#     end
#   end

#   @spec left_cumulative_lift(any, any, ((any, any) -> {any, any})) :: {any, any}
#   def left_cumulative_lift(traversable, acc, acc_map) do
#     traverse(acc, Witchcraft.Traversable.State.Left.new <|> curry(acc_map)).run(traversable)
#   end

#   def right_cumulative_lift() do
#     traverse(acc, Alge.State.Left.new <|> curry(acc_map)).run(traversable)
#   end
# end
