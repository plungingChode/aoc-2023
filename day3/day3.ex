defmodule Day3 do
  defmodule Schematic do
    @type t :: %__MODULE__{
            parts: list(PartNumber.t()),
            symbols: list(Symbol.t())
          }
    @enforce_keys [:parts, :symbols]
    defstruct [:parts, :symbols]
  end

  defmodule PartNumber do
    @type t :: %__MODULE__{
            pos: integer(),
            len: integer(),
            value: integer()
          }
    @enforce_keys [:pos, :len, :value]
    defstruct [:pos, :len, :value]
  end

  defmodule Symbol do
    @type t :: %__MODULE__{
            pos: integer(),
            sym: char()
          }

    @enforce_keys [:pos, :sym]
    defstruct [:pos, :sym]
  end

  @spec read_schematic(String.t()) :: Schematic.t()
  def read_schematic(s) do
    tokens = tokenize_schematic(s, %{parts: [], symbols: [], cursor: 0})

    %Schematic{
      parts: tokens.parts,
      symbols: tokens.symbols
    }
  end

  defp tokenize_schematic(s, tokens) when byte_size(s) > 0 do
    <<c::8, rest::binary>> = s

    {tokens, rest} =
      cond do
        c in ?1..?9 ->
          {value, rest} = Integer.parse(s)

          part = %PartNumber{
            pos: tokens.cursor,
            len: byte_size(s) - byte_size(rest),
            value: value
          }

          tokens = %{
            tokens
            | parts: tokens.parts ++ [part],
              cursor: tokens.cursor + part.len
          }

          {tokens, rest}

        c == ?. ->
          tokens = %{
            tokens
            | cursor: tokens.cursor + 1
          }

          {tokens, rest}

        true ->
          symbol = %Symbol{pos: tokens.cursor, sym: c}

          tokens = %{
            tokens
            | symbols: tokens.symbols ++ [symbol],
              cursor: tokens.cursor + 1
          }

          {tokens, rest}
      end

    tokenize_schematic(rest, tokens)
  end

  defp tokenize_schematic(_s, tokens) do
    tokens
  end

  @spec with_nearby_positions(PartNumber.t(), integer()) :: {PartNumber.t(), list(integer())}
  defp with_nearby_positions(part, line_width) do
    y = trunc(part.pos / line_width)
    x = part.pos - y * line_width

    # covers
    # +....+....
    # +1234+....
    # +....+....
    left_right_neighbors = [
      {x - 1, y + 1},
      {x - 1, y},
      {x - 1, y - 1},
      {x + part.len, y + 1},
      {x + part.len, y},
      {x + part.len, y - 1}
    ]

    # covers
    # .++++......
    # .1234......
    # .++++......
    top_bottom_neighbors =
      0..part.len
      |> Enum.flat_map(fn dx ->
        [{x + dx, y + 1}, {x + dx, y - 1}]
      end)

    in_bounds? = fn {x, y} ->
      true and
        x >= 0 and
        y >= 0 and
        x < line_width and
        y < line_width
    end

    neighbors = left_right_neighbors ++ top_bottom_neighbors
    neighbors = neighbors |> Enum.uniq() |> Enum.filter(in_bounds?)

    neighbors =
      for {x, y} <- neighbors do
        y * line_width + x
      end

    {part, neighbors}
  end

  @spec solve_part1(list(String.t()), integer()) :: integer()
  def solve_part1(input, line_width) do
    input = Enum.join(input)
    schematic = read_schematic(input)

    schematic.parts
    |> Enum.map(&with_nearby_positions(&1, line_width))
    |> Enum.filter(fn {_, neighbors} ->
      Enum.any?(schematic.symbols, fn sym ->
        Enum.member?(neighbors, sym.pos)
      end)
    end)
    |> Enum.map(fn {part, _} ->
      part.value
    end)
    |> Enum.sum()
  end

  @spec solve_part2(list(String.t()), integer()) :: integer()
  def solve_part2(input, line_width) do
    input = Enum.join(input)
    schematic = read_schematic(input)

    gears =
      schematic.symbols
      |> Enum.filter(fn symbol -> symbol.sym == ?* end)

    gears_pos = gears |> Enum.map(fn gear -> gear.pos end)

    schematic.parts
    |> Enum.map(&with_nearby_positions(&1, line_width))
    |> Enum.flat_map(fn {part, neighbors} ->
      nearby_gears =
        gears_pos
        |> Enum.filter(fn pos -> Enum.member?(neighbors, pos) end)

      if length(nearby_gears) > 0 do
        [{part, nearby_gears}]
      else
        []
      end
    end)
    |> Enum.reduce(%{}, fn {part, nearby_gears}, acc ->
      nearby_gears
      |> Enum.reduce(acc, fn pos, acc ->
        gear_parts = Map.get(acc, pos, []) ++ [part.value]
        Map.put(acc, pos, gear_parts)
      end)
    end)
    |> Enum.flat_map(fn {_, parts} ->
      if length(parts) == 2 do
        [Enum.product(parts)]
      else
        []
      end
    end)
    |> Enum.sum()
  end
end
