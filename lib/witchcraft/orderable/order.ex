import TypeClass

defmodule Witchcraft.Orderable.Order do
  @type t :: Equal.t | Greater.t | Less.t

  defmodule Greater do
    @type t :: %Greater{}
    defstruct []

    def new(), do: %Greater{}
  end

  defmodule Lesser do
    @type t :: %Lesser{}
    defstruct []

    def new(), do: %Lesser{}
  end

  defmodule Equal do
    @type t :: %Equal{}
    defstruct []

    def new(), do: %Equal{}
  end

  def greater, do: Greater.new
  def lesser,  do: Lesser.new
  def equal,   do: Equal.new

  defmacro is_order(item) do
    quote do
      unquote(item) == %Witchcraft.Orderable.Order.Greater{}
      or unquote(item) == %Witchcraft.Orderable.Order.Lesser{}
      or unquote(item) == %Witchcraft.Orderable.Order.Equal{}
    end
  end
end

defimpl TypeClass.Property.Generator, for: Witchcraft.Orderable.Order.Greater do
  alias Witchcraft.Orderable.Order
  def generate(_), do: Order.greater
end

defimpl TypeClass.Property.Generator, for: Witchcraft.Orderable.Order.Lesser do
  alias Witchcraft.Orderable.Order
  def generate(_), do: Order.lesser
end

defimpl TypeClass.Property.Generator, for: Witchcraft.Orderable.Order.Equal do
  alias Witchcraft.Orderable.Order
  def generate(_), do: Order.equal
end

definst Witchcraft.Setoid, for: Witchcraft.Orderable.Order.Greater do
  alias Witchcraft.Orderable.Order
  def equal?(_greater, %Order.Greater{}), do: true
  def equal?(_greater, _other), do: false
end

definst Witchcraft.Setoid, for: Witchcraft.Orderable.Order.Lesser do
  alias Witchcraft.Orderable.Order
  def equal?(_lesser, %Order.Lesser{}), do: true
  def equal?(_lesser, _other), do: false
end

definst Witchcraft.Setoid, for: Witchcraft.Orderable.Order.Equal do
  alias Witchcraft.Orderable.Order
  def equal?(_equal, %Order.Equal{}), do: true
  def equal?(_equal, _other), do: false
end

definst Witchcraft.Orderable, for: Witchcraft.Orderable.Order.Greater do
  alias Witchcraft.Orderable.Order

  def compare(_greater, %Order.Greater{}), do: Order.equal
  def compare(_greater, %Order.Lesser{}),  do: Order.greater
  def compare(_greater, %Order.Equal{}),   do: Order.greater
end

definst Witchcraft.Orderable, for: Witchcraft.Orderable.Order.Lesser do
  alias Witchcraft.Orderable.Order

  def compare(_lesser, %Order.Greater{}), do: Order.lesser
  def compare(_lesser, %Order.Lesser{}),  do: Order.equal
  def compare(_lesser, %Order.Equal{}),   do: Order.lesser
end

definst Witchcraft.Orderable, for: Witchcraft.Orderable.Order.Equal do
  alias Witchcraft.Orderable.Order

  def compare(_equal, %Order.Greater{}), do: Order.lesser
  def compare(_equal, %Order.Lesser{}),  do: Order.greater
  def compare(_equal, %Order.Equal{}),   do: Order.equal
end
