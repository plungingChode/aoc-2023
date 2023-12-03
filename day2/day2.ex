defmodule Day2 do
  defmodule Game do
    @moduledoc """
    Represents a game parsed from a string such as 
    ```
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    ```
    """
    @type t :: %__MODULE__{
            id: integer,
            sets: list(GameSet.t())
          }
    @enforce_keys [:sets, :id]
    defstruct [:sets, :id]
  end

  defmodule GameSet do
    @moduledoc """
    Represents a game set parsed from a string such as
    ```
    3 blue, 4 red, 1 green
    ```
    """
    @type t :: %__MODULE__{
            red: integer,
            green: integer,
            blue: integer
          }
    defstruct red: 0, green: 0, blue: 0
  end

  @doc """
  Parses a Game object from a string.
  """
  @spec parse_game(String.t()) :: Game
  def parse_game(input) do
    # Slice off "Game "
    input = String.slice(input, 5..-1)
    [id, sets] = String.split(input, ": ", parts: 2)
    {id, _} = Integer.parse(id)

    sets =
      String.split(sets, "; ")
      |> Enum.map(fn set ->
        opts =
          String.split(set, ", ")
          |> Enum.map(fn part ->
            [number, color] = String.split(part, " ", parts: 2)
            {number, _} = Integer.parse(number)

            color =
              case color do
                "red" -> :red
                "green" -> :green
                "blue" -> :blue
                _ -> throw("unknown color " <> color)
              end

            {color, number}
          end)

        struct!(GameSet, opts)
      end)

    %Game{
      id: id,
      sets: sets
    }
  end

  @max_red 12
  @max_green 13
  @max_blue 14

  @doc """
  Check if a game is possible according to the @max_* values.
  """
  @spec game_possible?(Game.t()) :: boolean()
  def game_possible?(game) do
    Enum.all?(game.sets, &gameset_possible?/1)
  end

  @doc """
  Check if a game set is possible according to the @max_* values.
  """
  @spec gameset_possible?(GameSet.t()) :: boolean()
  def gameset_possible?(set) do
    true and
      set.red <= @max_red and
      set.green <= @max_green and
      set.blue <= @max_blue
  end

  @spec solve_part1(list(String.t())) :: integer()
  def solve_part1(input) do
    input
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&game_possible?/1)
    |> Enum.map(fn game -> game.id end)
    |> Enum.sum()
  end

  @doc """

  """
  @spec game_max_cube_count(Game.t()) :: GameSet.t()
  def game_max_cube_count(game) do
    result =
      Enum.reduce(
        game.sets,
        [
          red: 0,
          green: 0,
          blue: 0
        ],
        fn set, acc ->
          acc =
            if set.red > 0 and set.red > acc[:red] do
              Keyword.put(acc, :red, set.red)
            else
              acc
            end

          acc =
            if set.green > 0 and set.green > acc[:green] do
              Keyword.put(acc, :green, set.green)
            else
              acc
            end

          acc =
            if set.blue > 0 and set.blue > acc[:blue] do
              Keyword.put(acc, :blue, set.blue)
            else
              acc
            end

          acc
        end
      )

    struct!(GameSet, result)
  end

  @spec gameset_power(GameSet.t()) :: integer()
  def gameset_power(set) do
    set.red * set.green * set.blue
  end

  @spec solve_part2(list(String.t())) :: integer()
  def solve_part2(input) do
    input
    |> Enum.map(&parse_game/1)
    |> Enum.map(&game_max_cube_count/1)
    |> Enum.map(&gameset_power/1)
    |> Enum.sum()
  end
end
