defmodule Witchcraft.Hierarchy do

  defmacro __using__(_) do
    quote bind_quoted: [module: __MODULE__] do
      require module
      import module
    end
  end

  ### ==========
  # Extend Class
  # ============

  @spec defreify([module]) :: :ok | no_return
  defmacro defreify(protocol) when is_list(protocols) do
    quote bind_quoted: [protocol: protocol] do
      Enum.each(protocol.CLASS_METADATA.parents, fn protocol ->
        Protocol.assert_impl!(protocol, __MODULE__)
      end)
    end
  end

  @spec defreify(module) :: :ok | no_return
  defmacro defreify(protocol), do: protocol |> List.wrap |> defreify

  ### ===
  # Class
  # =====

  defmacro defclass(name, do: block) do
    defprotocol name, do: block
  end

  defmacro defclass(name, parents: parents, do: block) do
    quote bind_quoted: [name: name, parents: parents, block: block] do
      defmodule name.CLASS_METADATA do
        @moduledoc "Holds onto defclass metadata so that it's available at compile time"

        @doc "The parents that this class depends on"
        @spec parents() :: [atom]
        def parents, do: parents
      end

      defprotocol name, do: block
    end
  end

  defmacro classimpl(name, opts, do_block \\ []) do
    quote bind_quoted: [name: name, opts: opts, do_block: do_block] do
      name.requirements
      defimpl name, opts, do_block
    end
  end
end
