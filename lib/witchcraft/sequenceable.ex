use TypeClass

defclass Witchcraft.Sequenceable do
  extend Wtchcraft.Applicative
  extend Wtchcraft.Traversable

  defmacro __using__(_) do
    quote do
      use Witchcraft.Applicative
      use Witchcraft.Traversable
    end
  end

  where do
    def sequence(sequenceable)
  end

  properties do

  end
end
