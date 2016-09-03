defmodule Witchcraft.Monoid.Identity do
  @callback identity(any) :: any
end

# Witchcraft.Monoid
# defmacro __using__(_) do
#   quote do
#     @behaviour Witchcraft.Monoid.Behaviour
#     use Witchcraft.Function
#     use Witchcraft.Operator
#   end
# end
