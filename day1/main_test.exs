ExUnit.start(
  capture_log: true
)

defmodule Day1Test do
  use ExUnit.Case

  test "adds digits correctly" do
    result = Day1.solve_part1([
      "1abc2",
      "pqr3stu8vwx",
      "a1b2c3d4e5f",
      "treb7uchet",
    ])
    assert(result == 142)
  end

  test "adds conjoined digits correctly (part 2)" do
    result = Day1.solve_part2([
      "twone"
    ])
    assert(result == 21)
  end

  test "adds digits correctly (part 2)" do
    result = Day1.solve_part2([
      "two1nine",
      "eightwothree",
      "abcone2threexyz",
      "xtwone3four",
      "4nineeightseven2",
      "zoneight234",
      "7pqrstsixteen",
    ])
    assert(result == 281)
  end
end
