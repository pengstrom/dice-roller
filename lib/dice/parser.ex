defmodule Dice.Parser do

  @type rollspec :: String.t
  @type parser_result :: {:ok, Dice.roll, rollspec} | {:error, rollspec}
  @type parser_results :: [parser_result]

  @spec parser(rollspec) :: parser_results
  def parser(spec) do
    spec
    |> String.split("+")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&to_dice/1)
  end

  defp to_dice(spec) do
    %{spec: spec, result: nil}
    |> dice_const
    |> dice_die
    |> to_result
  end

  defp dice_const(%{spec: spec, result: nil} = ctx) do
    try do
      c = String.to_integer(spec)
      %{ctx | result: Dice.const(c)}
    rescue
      ArgumentError ->
        %{spec: spec, result: nil}
    end
  end
  defp dice_const(ctx), do: ctx

  defp dice_die(%{spec: spec, result: nil} = ctx) do
    res = Regex.named_captures(~r/^(?<num>\d+)?d(?<sides>\d+)(x(?<mult>\d+))?$/, spec)
    case res do
      nil -> ctx
      %{"mult" => mm, "sides" => ms, "num" => mn} ->
        m = safe_integer mm
        n = safe_integer mn
        s = safe_integer ms
        case s do
          nil -> ctx
          x ->
            res = Dice.dice(x, n, m)
            %{ctx | result: res}
        end
    end
  end
  defp dice_die(ctx), do: ctx

  defp safe_integer(str) do
    try do
      String.to_integer(str)
    rescue
      ArgumentError -> nil
    end
  end

  defp to_result(%{spec: spec, result: nil}), do: {:error, spec}
  defp to_result(%{spec: spec, result: res}), do: {:ok, res, spec}

end
