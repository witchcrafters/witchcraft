defmodule Witchcraft.Internal do
  @moduledoc """
  A module for handling `use Witchcraft` and other modules

  Provides support for overriding `Kernel` functions and for auto dependencies using via `__using__/1` macro.
  """

  @doc ~S"""
  Generates `Kernel` import and `__using__/1` macro in module where used.

  ## Options

  - `:overrides` – List of overrides in module where used
  - `:deps` – List of modules that will be used in generated `__using__/1` macro

  ## Generated `__using__(opts \\ [])` macro supports the following options:

  - `:override_kernel` – If true, overrides function from `Kernel` in module where used. Defaults to true
  - `:except` and `:only` – Keyword of functions (Like in [import](https://hexdocs.pm/elixir/Kernel.SpecialForms.html#import/2-selector)). Example: `[fun: <arity>]` where `<arity>` is function `fun` arity
  """
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

  @doc false
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

  defp use_multi(modules, opts) do
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
