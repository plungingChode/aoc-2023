File.read!("./input")
|> String.split("\n")
# |> Day1.solve_part1()
|> Day1.solve_part2()
|> IO.inspect(charlists: :as_lists)
