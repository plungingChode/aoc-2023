defmodule Day1 do
  @doc """
  Finds all digit characters of `s`.
  """
  @spec keep_digits(binary()) :: charlist()
  def keep_digits(s) do
    :binary.bin_to_list(s)
    |> Enum.filter(fn c -> c in ?1..?9 end)
  end

  @doc """
  Keeps the first and last elements of a list. If the list contains no
  elements returns an empty list. If it contains a single element, returns a
  list containing the element twice.
  """
  @spec first_and_last(list(any)) :: list(any)
  def first_and_last(list) do
    case length(list) do
      0 -> []
      1 -> [hd(list), hd(list)]
      _ -> [hd(list), Enum.at(list, -1)]
    end
  end

  @doc """
  Combine a charlist containing only digit characters into an integer value.
  """
  @spec charlist_digits_to_int(charlist()) :: integer()
  def charlist_digits_to_int(digits) do
    Enum.reduce(digits, 0, fn d, acc ->
      acc * 10 + d - 48
    end)
  end

  @spec solve_part1(list(binary)) :: integer()
  def solve_part1(lines) do
    lines
    |> Enum.map(&keep_digits/1)
    |> Enum.map(&first_and_last/1)
    |> Enum.map(&charlist_digits_to_int/1)
    |> Enum.sum()
  end

  @digits_re ~r/one|two|three|four|five|six|seven|eight|nine|[0-9]/
  @digits_re_reversed ~r/[0-9]|enin|thgie|neves|xis|evif|ruof|eerht|owt|eno/
  @digits_values %{
    "one" => 1,
    "1" => 1,
    "two" => 2,
    "2" => 2,
    "three" => 3,
    "3" => 3,
    "four" => 4,
    "4" => 4,
    "five" => 5,
    "5" => 5,
    "six" => 6,
    "6" => 6,
    "seven" => 7,
    "7" => 7,
    "eight" => 8,
    "8" => 8,
    "nine" => 9,
    "9" => 9
  }

  @doc """
  Finds the first and last digit symbols (digits or words) in `s`
  and returns their numeric values.
  """
  @spec keep_first_last_digits(binary()) :: list(integer)
  def keep_first_last_digits(s) do
    first =
      Regex.run(@digits_re, s)
      |> List.flatten()
      |> hd

    last =
      Regex.run(@digits_re_reversed, String.reverse(s))
      |> List.flatten()
      |> hd
      |> String.reverse()

    [@digits_values[first], @digits_values[last]]
  end

  @doc """
  Combine a list of integer digits into a single integer.
  """
  @spec digits_to_int(list(integer)) :: integer()
  def digits_to_int(digits) do
    Enum.reduce(digits, 0, fn d, acc ->
      acc * 10 + d
    end)
  end

  @spec solve_part2(list(binary)) :: integer()
  def solve_part2(lines) do
    lines
    |> Enum.filter(fn s -> byte_size(s) > 0 end)
    |> Enum.map(&keep_first_last_digits/1)
    |> Enum.map(&digits_to_int/1)
    |> Enum.sum()
  end
end
