ExUnit.start(capture_log: true)

defmodule Day2Test do
  use ExUnit.Case

  test "parses input correctly" do
    input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    actual = Day2.parse_game(input)

    expected = %Day2.Game{
      id: 1,
      sets: [
        %Day2.GameSet{blue: 3, red: 4},
        %Day2.GameSet{red: 1, green: 2, blue: 6},
        %Day2.GameSet{green: 2}
      ]
    }

    assert(expected == actual)
  end

  test "solves example input (part 1)" do
    input = "
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    "

    input =
      String.split(input, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn s -> byte_size(s) > 0 end)

    actual = Day2.solve_part1(input)

    assert(8 == actual)
  end

  test "solves example input (part 2)" do
    input = "
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    "

    input =
      String.split(input, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn s -> byte_size(s) > 0 end)

    actual = Day2.solve_part2(input)

    assert(2286 == actual)
  end
end
