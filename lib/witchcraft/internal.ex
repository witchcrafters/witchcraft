defmodule Witchcraft.Internal do
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

  def import_helper(opts, overrides, deps, module) do
    excepts = Keyword.get(opts, :except, [])
    only = Keyword.get(opts, :only)
    deps_quoted = use_multi(deps, opts)

    if Keyword.get(opts, :override_kernel, true) do
      kernel_imports = kernel_imports(overrides -- excepts, only)
      module_imports = module_imports(excepts, only)

      quote do
        import Kernel, unquote(kernel_imports)

        unquote(deps_quoted)

        import unquote(module), unquote(module_imports)
      end
    else
      module_imports = module_imports(Enum.uniq(overrides ++ excepts), only)

      quote do
        unquote(deps_quoted)

        import unquote(module), unquote(module_imports)
      end
    end
  end

  def use_multi(modules, opts) do
    for module <- modules do
      quote do
        use unquote(module), unquote(opts)
      end
    end
  end

  defp kernel_imports(excepts, nil), do: Macro.escape(except: excepts)
  defp kernel_imports(_, only), do: Macro.escape(except: only)

  defp module_imports(excepts, nil), do: Macro.escape(except: excepts)
  defp module_imports(excepts, only), do: Macro.escape(only: only -- excepts)
end
