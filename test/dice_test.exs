defmodule DiceTest do
  use ExUnit.Case
  doctest Dice

  test "greets the world" do
    assert Dice.hello() == :world
  end
end
