File.read!("./input")
|> String.split("\n")
|> Enum.map(&String.trim/1)
|> Enum.filter(fn s -> byte_size(s) > 0 end)
# |> Day2.solve_part1()
|> Day2.solve_part2()
|> IO.inspect(charlists: :as_lists)