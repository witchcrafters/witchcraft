import TypeClass

defclass Witchcraft.Setoid do
  @modueldoc ~S"""
  A setoid is a type with an equivalence relation (able to compare of equality).
  Since some types have differing concepts of equality, this allows overriding
  the behaviour from `Kernel.==/2`. To get the Setoid `==` operator override,
  simply `use Witchcraft.Setoid`.
  """

  alias __MODULE__
  import Kernel, except: [==: 2]

  defmacro __using__(_) do
    quote do
      import Kernel, except: [==: 2]
      import unquote(__MODULE__)
    end
  end

  where do
    @doc ~S"""
    Compare two
    """
    def equal?(a, b)
  end

  defalias a == b, [as: :equal?]

  properties do
    def reflexivity(data) do
      a = generate(data)
      a |> Setoid.equal?(a)
    end

    def symmetry(data) do
      a = generate(data)
      b = generate(data)

      Kernel.==(Setoid.equal?(a, b), Setoid.equal?(b, a))
    end

    def transitivity(data) do
      a = b = c = generate(data)

      Setoid.equal?(a, b) and Setoid.equal?(b, c) and Setoid.equal?(a, c)
    end
  end
end

definst Witchcraft.Setoid, for: Integer do
  def equal?(a, b) when is_integer(b), do: Kernel.==(a, b)
end

definst Witchcraft.Setoid, for: Float do
  def equal?(a, b) when is_float(b), do: Kernel.==(a, b)
end

definst Witchcraft.Setoid, for: BitString do
  def equal?(a, b) when is_bitstring(b), do: Kernel.==(a, b)
end

definst Witchcraft.Setoid, for: Tuple do
  def equal?(a, b) when is_tuple(b), do: Kernel.==(a, b)
end

definst Witchcraft.Setoid, for: List do
  def equal?(a, b) when is_list(b), do: Kernel.==(a, b)
end

definst Witchcraft.Setoid, for: Map do
  def equal?(a, b) when is_map(b), do: Kernel.==(a, b)
end
