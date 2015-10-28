defmodule Witchcraft.Functor.Properties do
  @moduledoc """
  Check samples of your functor to confirm that your data adheres to the
  functor properties. *All members* of your datatype should adhere to these rules.
  They are placed here as a quick way to spotcheck some of your values.
  """

  import Witchcraft.Functor
  import Witchcraft.Functor.Functions

  def spotcheck_associates_all_objects do

  end

  def spotcheck_preserve_identity do
    F(id(x)) == id(F(x)) for every object
  end

  def spotcheck_preserve_compositon do
    F(g . f) == F(g) . F(f), for all f : X -> Y, g : Y -> Z
  end
end
