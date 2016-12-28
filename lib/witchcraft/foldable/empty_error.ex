defmodule Witchcraft.Foldable.EmptyError do
  alias __MODULE__

  @type t :: %EmptyError{message: String.t, data: any, plug_status: pos_integer}

  defexception message: "Unable to process empty data", data: nil, plug_status: 500

  defmacro new(data) do
    quote do
      %{module: module_name, function: {fun_name, arity}} = __CALLER__

      %Witchcraft.Foldable.EmptyError{
        data: unquote(data),
        message: "Unable to process empty data in #{module_name}.#{fun_name}/#{arity}"
      }
    end
  end
end
