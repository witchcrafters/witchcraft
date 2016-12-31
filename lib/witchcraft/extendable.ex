import TypeClass

defclass Witchcraft.Extendable do
  where do
    def nest(extendable)
  end

  properties do

  end
end

definst Witchcraft.Extendable, for: List do
  def nest(list) do
    list
    |> Enum.reverse
    |> Enum.scan([], fn(x, acc) -> [x | acc] end)
    |> Enum.reverse
    # Obviously make a cleaner version ^^^
  end
end

# instance Extend Maybe where
# duplicated Nothing = Nothing
# duplicated j = Just j

# instance Extend (Either a) where
# duplicated (Left a) = Left a
# duplicated r = Right r

# instance Extend ((,)e) where
# duplicated p = (fst p, p)

# instance Semigroup m => Extend ((->)m) where
# duplicated f m = f . (<>) m
