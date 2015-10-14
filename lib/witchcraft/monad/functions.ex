defmodule Witchcraft.Monad.Functions do
  alias Witchcraft.Monad

  @spec bind(ma, (a -> mb)) :: mb
  def bind(data, endofunctor) do
    data
    |> fmap endofunctor
    |> join
  end

  @spec liftM(ma, (a -> r)) :: mr
  def liftM(ma, func), do: bind(ma, &(return(func.(&1))))

  @spec liftM2(ma1, ma2, ((a1, a2) -> r)) :: mr
  def liftM2(ma1, ma2, func) do
    bind(ma1, fn(x1) ->
      bind(ma2, fn(x2) ->
        return(func.(x1, x2))
      end)
    end)
  end

  def liftM3(ma1, ma2, ma3, func) do
    bind(ma1, fn(x1) ->
      bind(ma2, fn(x2) ->
        bind(ma3, fn(x3) ->
          return(func.(x1, x2, x3))
        end)
      end)
    end)
  end

  def liftM4(ma1, ma2, ma3, ma4, func) do
    bind(ma1, fn(x1) ->
      bind(ma2, fn(x2) ->
        bind(ma3, fn(x3) ->
          bind(ma4, fn(x4) ->
            return(func.(x1, x2, x3, x4))
          end)
        end)
      end)
    end)
  end

  def liftM5(ma1, ma2, ma3, ma4, ma5, func) do
    bind(ma1, fn(x1) ->
      bind(ma2, fn(x2) ->
        bind(ma3, fn(x3) ->
          bind(ma4, fn(x4) ->
            bind(ma4, fn(x5) ->
              return(func.(x1, x2, x3, x4, x5))
            end)
          end)
        end)
      end)
    end)
  end
end
