defmodule Dice do
  @moduledoc """
  Creating and rolling dice.
  """

  @type const :: {:const, pos_integer}
  @type dice :: {:dice, pos_integer, pos_integer, pos_integer}
  @type roll :: const | dice

  @doc """
  Creates a s-sided die meant to be rolled n times and the result multiplied
  by m.
  """
  @spec dice(pos_integer, pos_integer, pos_integer) :: dice
  def dice(s \\ 6, n \\ 1, m \\ 1) do
    {:dice, s || 6, n || 1, m || 1}
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

  def roll(parsed) do
    parsed
    |> Enum.map(&roll_parsed/1)
  end

  defp roll_parsed({:ok, res, spec}) do
    x = roll_one(res)
    {:ok, {x, res, spec}}
  end
  defp roll_parsed(parsed), do: parsed
end
