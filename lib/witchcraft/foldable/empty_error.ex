defmodule Witchcraft.Foldable.EmptyError do
  alias __MODULE__

  @type t :: %EmptyError{message: String.t, data: any, plug_status: pos_integer}
  @base_message "Unable to process empty data"

  defexception message: @base_message, data: nil, plug_status: 500

  defmacro new(data) do
    quote do
      module_name       = __MODULE__
      case __ENV__.function do
        {fun_name, arity} ->
          %EmptyError{
            data: unquote(data),
            message: "Unable to process empty data in #{module_name}.#{fun_name}/#{arity}"
          }

        nil -> %EmptyError{data: unquote(data)}
      end
    end
  end
end
