defmodule Day4 do
  def numbers_from_segment(segment) do
    segment
    |> String.split(" ", trim: true)
    |> Enum.map(fn num ->
      {value, _} = Integer.parse(num)
      value
    end)
  end

  def line_to_wins(line) do
    {winning, mine} =
      line
      |> String.split(": ", parts: 2)
      |> Enum.at(1)
      |> String.split(" | ")
      |> Enum.map(&numbers_from_segment/1)
      |> List.to_tuple()

    mine
    |> Enum.count(&Enum.member?(winning, &1))
  end

  def wins_to_points(wins) do
    if wins == 0 do
      0
    else
      :math.pow(2, wins - 1)
    end
  end

  def solve_part1(input) do
    input
    |> Enum.map(&line_to_wins/1)
    |> Enum.map(&wins_to_points/1)
    |> Enum.sum()
    |> trunc()
  end

  def wins_as_cards(wins_list, idx) when idx < length(wins_list) - 1 do
    %{wins: wins, count: count} = Enum.at(wins_list, idx)
    from = idx
    to = max(idx + wins, from)

    wins_list =
      wins_list
      |> Enum.with_index()
      |> Enum.map(fn {win, add_idx} ->
        if add_idx > idx and add_idx in from..to do
          %{win | count: win[:count] + count}
        else
          win
        end
      end)

    wins_as_cards(wins_list, idx + 1)
  end

  def wins_as_cards(wins, _idx) do
    wins
    |> Enum.map(& &1[:count])
    |> Enum.sum()
  end

  def solve_part2(input) do
    input
    |> Enum.map(&line_to_wins/1)
    |> Enum.map(fn wins -> %{wins: wins, count: 1} end)
    |> wins_as_cards(0)
  end
end
