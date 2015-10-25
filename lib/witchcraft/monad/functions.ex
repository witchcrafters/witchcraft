defmodule Witchcraft.Monad.Functions do
  alias Witchcraft.Functor,     as: F
  alias Witchcraft.Applicative, as: A
  alias Witchcraft.Monad,       as: M

  @type a  :: any
  @type ma :: any
  @type mb :: any

  def return(a), do: A.pure(a)

  @spec bind(ma, (a -> mb)) :: mb
  def bind(data, endofunctor) do
    data
    |> F.lift endofunctor
    |> M.join
  end

  # @doc "Sugar for bind"
  # defmacro left ~>> right do

  # end

  # @doc "Sugar for 'reverse bind'"
  # defmacro left <<~ right do

  # end

  # mapM == Applicative.traverse
  # def mapM(as, f) do
  #   Witchcraft.Foldable.foldr(&(lift_concat(&1, &2)), return([]), as)
  # end

  # defp lift_concat(a, r) do
  #   M.bind(f.(a), fn(x) ->
  #     M.bind(r, fn(xs) ->
  #       return(Enum.concat([x], xs))
  #     end)
  #   end)
  # end

  # def forM do

  # end

  # def sequence do

  # end

  # def compose_lr do

  # end

  # def compose_rl do

  # end

  # def forever do

  # end

  # def zip_with do

  # end

  # def fold do

  # end

  # def replicate do

  # end

  # @spec liftM(ma, (a -> r)) :: mr
  # def liftM(ma, func), do: bind(ma, &(return(func.(&1))))

  # @spec liftM2(ma1, ma2, ((a1, a2) -> r)) :: mr
  # def liftM2(ma1, ma2, func) do
  #   bind(ma1, fn(x1) ->
  #     bind(ma2, fn(x2) ->
  #       return(func.(x1, x2))
  #     end)
  #   end)
  # end

  # def liftM3(ma1, ma2, ma3, func) do
  #   bind(ma1, fn(x1) ->
  #     bind(ma2, fn(x2) ->
  #       bind(ma3, fn(x3) ->
  #         return(func.(x1, x2, x3))
  #       end)
  #     end)
  #   end)
  # end

  # def liftM4(ma1, ma2, ma3, ma4, func) do
  #   bind(ma1, fn(x1) ->
  #     bind(ma2, fn(x2) ->
  #       bind(ma3, fn(x3) ->
  #         bind(ma4, fn(x4) ->
  #           return(func.(x1, x2, x3, x4))
  #         end)
  #       end)
  #     end)
  #   end)
  # end

  # def liftM5(ma1, ma2, ma3, ma4, ma5, func) do
  #   bind(ma1, fn(x1) ->
  #     bind(ma2, fn(x2) ->
  #       bind(ma3, fn(x3) ->
  #         bind(ma4, fn(x4) ->
  #           bind(ma5, fn(x5) ->
  #             return(func.(x1, x2, x3, x4, x5))
  #           end)
  #         end)
  #       end)
  #     end)
  #   end)
  # end
end
