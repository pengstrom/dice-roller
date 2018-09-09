defmodule Dice do
  import NimbleParsec

  @moduledoc """
  Documentation for Dice.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dice.hello()
      :world

  """
  def hello do
    :world
  end

  def dice(s \\ 6, n \\ 1, m \\ 1) do
    {:dice, s, n, m}
  end

  def const(n) do
    {:const, n}
  end

  def roll_one({:dice, s, n, m}) do
    for _n <- 1..n, do: m * Enum.random(1..s)
  end
  def roll_one({:const, n}) do
    [n]
  end

  def roll_many(dice) do
    dice
    |> Enum.map(&roll_one/1)
    |> Enum.concat
  end

  multiplier_parser =
    ignore(string("x"))
    |> integer(min: 1)

  dice_parser =
    optional(integer(1))
    |> ignore(string("d"))
    |> integer(min: 1)
    |> concat(optional(multiplier_parser))
    |> tag(:dice)

  const_parser =
    integer(min: 1)
    |> tag(:const)

  defparsec :roll_parser, dice_parser

end
