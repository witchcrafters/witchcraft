defmodule Witchcraft.DoNotationTest do
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

  test "return from multiple draws" do
    done =
      chain do
        a <- [1, 2, 3]
        b <- [4, 5, 6]
        [a * b]
      end

    assert done == [4, 5, 6, 8, 10, 12, 12, 15, 18]
  end

  test "draw one line and immedietly use it" do
    done =
      chain do
        a <- [1, 2, 3]
        [a, a * 10, a * 100]
      end

    assert done == [1, 10, 100, 2, 20, 200, 3, 30, 300]
  end

  test "draw one line and use it repeatedly" do
    done =
      chain do
        a <- [1, 2, 3]
        [a]
        [a]
      end

    assert done == [1, 2, 3]
  end

  test "use recursively drawn elements" do
    done =
      chain do
        a <- [1, 2, 3]
        b <- [a * 10]
        [a + b]
      end

    assert done == [11, 22, 33]
  end

  test "multiple recursive uses" do
    done =
      chain do
        a <- [1, 2, 3]
        b <- [a * 10]
        c <- [a + b]
        [a, b, c]
      end

    assert done == [1, 10, 11, 2, 20, 22, 3, 30, 33]
  end

  test "top let bindings" do
    done =
      chain do
        let values = [1, 2, 3]
        a <- values
        b <- [a * 10]
        c <- [a + b]
        [a, b, c]
      end

    assert done == [1, 10, 11, 2, 20, 22, 3, 30, 33]
  end

  test "intermediate let bindings" do
    done =
      chain do
        a <- [1, 2, 3]
        b <- [a * 10]
        let foo = b / a
        c <- [foo * foo]
        [a, b, c]
      end

    assert done == [1.0, 10.0, 100.0, 2.0, 20.0, 100.0, 3.0, 30.0, 100.0]
  end

  test "destructuring let" do
    done =
      chain do
        a <- [1, 2]
        b <- [3, 4]
        let [h | _] = [a * b]
        [h, h, h]
      end

    assert done == [3, 3, 3, 4, 4, 4, 6, 6, 6, 8, 8, 8]
  end

  test "recursive lets" do
    done =
      chain do
        a <- [1, 2]
        b <- [3, 4]
        let [h | _] = [a * b]
        c <- [a, b, h]
        let _tens = c * 10
        d <- [c - 1, c + 1]
        [a, b, c, d]
      end

    assert done == [
             1,
             3,
             1,
             0,
             1,
             3,
             1,
             2,
             1,
             3,
             3,
             2,
             1,
             3,
             3,
             4,
             1,
             3,
             3,
             2,
             1,
             3,
             3,
             4,
             1,
             4,
             1,
             0,
             1,
             4,
             1,
             2,
             1,
             4,
             4,
             3,
             1,
             4,
             4,
             5,
             1,
             4,
             4,
             3,
             1,
             4,
             4,
             5,
             2,
             3,
             2,
             1,
             2,
             3,
             2,
             3,
             2,
             3,
             3,
             2,
             2,
             3,
             3,
             4,
             2,
             3,
             6,
             5,
             2,
             3,
             6,
             7,
             2,
             4,
             2,
             1,
             2,
             4,
             2,
             3,
             2,
             4,
             4,
             3,
             2,
             4,
             4,
             5,
             2,
             4,
             8,
             7,
             2,
             4,
             8,
             9
           ]
  end
end
