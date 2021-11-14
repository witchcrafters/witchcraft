defmodule Witchcraft.Internal do
  def use_multi(modules, opts) do
    for module <- modules do
      quote do
        use unquote(module), unquote(opts)
      end
    end
  end

  def import_helper(opts, overrides, deps, module) do
    excepts = Keyword.get(opts, :except, [])
    deps_quoted = use_multi(deps, opts)

    if Access.get(opts, :override_kernel, true) do
      kernel_imports = Macro.escape(except: overrides -- excepts)
      module_imports = Macro.escape(except: excepts)

      quote do
        import Kernel, unquote(kernel_imports)

        unquote(deps_quoted)

        import unquote(module), unquote(module_imports)
      end
    else
      module_imports = Macro.escape(except: Enum.uniq(overrides ++ excepts))

      quote do
        unquote(deps_quoted)

        import unquote(module), unquote(module_imports)
      end
    end
  end

  defmacro __using__(opts \\ []) do
    overrides = Keyword.get(opts, :overrides, [])
    deps = Keyword.get(opts, :deps, [])

    quote do
      @overrides unquote(overrides)

      import Kernel, except: unquote(overrides)

      defmacro __using__(opts \\ []) do
        Witchcraft.Internal.import_helper(opts, unquote(overrides), unquote(deps), __MODULE__)
      end
    end
  end
end
