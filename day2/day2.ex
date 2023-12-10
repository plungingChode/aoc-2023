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

  # Here the GameSet become GameCube
  defmodule GameCube do
    @moduledoc """
    Represents a game set parsed from a string such as
    ```
    3 blue, 4 red, 1 green
    ```
    """
    @type t :: %__MODULE__{
            color: Keyword,
            count: integer,
          }
    defstruct color: nil, count: 0
  end

  @doc """
  Parses a Game object from a string.
  """
  @spec parse_game(String.t()) :: Game
  def parse_game(input) do
    # Slice off "Game "
    input = String.slice(input, 5..-1)
    [id, sets] = String.split(input, ": ", parts: 2)
    id = String.to_integer(id)

    # Instead of treating sets here, you can just consider every cubes (with a regex?)
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
        # I think you can consider atomic value of the game to be a `cube` instead of a set, even if
        # the `set` solution is a great idea because you can treat set by set instead of cube by cube,
        # what do you think ?
        game.cubes,
        %{ :red => 0, :green => 0, :blue => 0 },
        # Here the set become a `cube` containing a `color` and a `count`.
        fn cube, acc ->
          # Can't you generalise the solution with only a `color` and a `count` field ? That would be great
          # and it would allow to use the powerful Map.update like this (see below).
          # The `set.color` would contain `:red`, `:green` or `:blue`.
          # The `set.color` the associated count.
          Map.update(acc, set.color, set.count, fn existing_count ->
            max(existing_count, set.count)
          end)
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
