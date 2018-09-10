defmodule DiceTest do
  use ExUnit.Case
  doctest Dice

  test "Generates dice" do
    assert Dice.dice() == {:dice, 6, 1, 1}
    assert Dice.dice(nil, nil, nil) == {:dice, 6, 1, 1}
    assert Dice.dice(4) == {:dice, 4, 1, 1}
    assert Dice.dice(4, nil, nil) == {:dice, 4, 1, 1}
    assert Dice.dice(4, 5) == {:dice, 4, 5, 1}
    assert Dice.dice(4, 5, nil) == {:dice, 4, 5, 1}
    assert Dice.dice(4, 5, 6) == {:dice, 4, 5, 6}
  end

  test "Generates constant dice" do
    assert Dice.const(1) == {:const, 1}
    assert Dice.const(2) == {:const, 2}
  end

  test "Parses constants" do
    assert Dice.Parser.parser(" 1") == [{:ok, {:const, 1}, "1"}]
    assert Dice.Parser.parser("10  ") == [{:ok, {:const, 10}, "10"}]
  end

  test "Parses dice" do
    assert Dice.Parser.parser("d6") == [{:ok, {:dice, 6, 1, 1}, "d6"}]
    parserTest(" 2d6", {:dice, 6, 2, 1})
    parserTest(" d6x4", {:dice, 6, 1, 4})
    parserTest("2d6x4 ", {:dice, 6, 2, 4})
  end

  test "Parses sums" do
    assert Dice.Parser.parser(" 1 + d6 + 4d13x5+foo") == [
      {:ok, {:const, 1}, "1"},
      {:ok, {:dice, 6, 1, 1}, "d6"},
      {:ok, {:dice, 13, 4, 5}, "4d13x5"},
      {:error, "foo"}
    ]
  end

  defp parserTest(spec, res) do
    assert Dice.Parser.parser(spec) == [{:ok, res, String.trim(spec)}]
  end
end
