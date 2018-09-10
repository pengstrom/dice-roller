defmodule Dice do

  @type const :: {:const, pos_integer}
  @type dice :: {:dice, pos_integer, pos_integer, pos_integer}
  @type roll :: const | dice

  @spec dice(pos_integer, pos_integer, pos_integer) :: dice
  def dice(s \\ 6, n \\ 1, m \\ 1) do
    {:dice, s, n || 1, m || 1}
  end

  @spec const(pos_integer) :: const
  def const(n) do
    {:const, n}
  end

  @spec roll_one(roll) :: [pos_integer]
  def roll_one({:dice, s, n, m}) do
    for _n <- 1..n, do: m * Enum.random(1..s)
  end
  def roll_one({:const, n}) do
    [n]
  end

  @spec roll_many([roll]) :: [pos_integer]
  def roll_many(dice) do
    dice
    |> Enum.map(&roll_one/1)
    |> Enum.concat
  end
end
