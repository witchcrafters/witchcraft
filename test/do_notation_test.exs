defmodule WitchcraftTest do
  use ExUnit.Case, async: true
  use Witchcraft.Chain

  test "single line" do
    done =
      chain do
        [1, 2, 3]
      end

    assert done == [1, 2, 3]
  end

  test "multiple lines, default then" do
    done =
      chain do
        [1, 2, 3]
        [4, 5, 6]
      end

    assert done == [4, 5, 6, 4, 5, 6, 4, 5, 6]
  end

  test "draw one line and immedietly use it" do
    done =
      chain do
        a <- [1, 2, 3]
        [a, a * 10, a * 100]
      end

    assert done == [1, 10, 100, 2, 20, 200, 3, 30, 300]
  end

  # test "use recursively drawn elements" do
  #   done =
  #     chain do
  #       a <- [1, 2, 3]
  #       b <- [a * 10]
  #       [a + b]
  #     end

  #   assert done == [11, 22, 33]
  # end
end
