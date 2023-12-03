ExUnit.start(capture_log: true)

defmodule Day3Test do
  use ExUnit.Case

  test "parses input correctly" do
    input = "
467..114..
...*......
..35..633.
......#...
            "

    expected =
      %Day3.Schematic{
        parts: [
          %Day3.PartNumber{pos: 0, len: 3, value: 467},
          %Day3.PartNumber{pos: 5, len: 3, value: 114},
          %Day3.PartNumber{pos: 22, len: 2, value: 35},
          %Day3.PartNumber{pos: 26, len: 3, value: 633}
        ],
        symbols: [
          %Day3.Symbol{pos: 13, sym: ?*},
          %Day3.Symbol{pos: 36, sym: ?#}
        ]
      }

    actual =
      String.split(input, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn s -> byte_size(s) > 0 end)
      |> Enum.join()
      |> Day3.read_schematic()

    assert(expected == actual)
  end

  test "solves example input (part 1)" do
    input = "
467..114..
...*......
..35..633.
......#...
            "

    expected = 467 + 35 + 633

    actual =
      String.split(input, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn s -> byte_size(s) > 0 end)
      |> Day3.solve_part1(10)

    assert(expected == actual)
  end

  test "solves larger example input (part 1)" do
    input = "
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
            "

    actual =
      String.split(input, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn s -> byte_size(s) > 0 end)
      |> Day3.solve_part1(10)

    assert(4361 == actual)
  end

  test "solves example input (part 2)" do
    input = "
467..114..
...*......
..35..633.
......#...
            "

    expected = 467 * 35

    actual =
      String.split(input, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn s -> byte_size(s) > 0 end)
      |> Day3.solve_part2(10)

    assert(expected == actual)
  end
end
