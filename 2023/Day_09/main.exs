defmodule Day_09 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) end)
  end

  def get_next(l, part2 \\ false) do
    if Enum.all?(l, & &1 == 0) do 0 else
      diffs = Enum.chunk_every(l, 2, 1, :discard) |> Enum.map(fn [a,b] -> b - a end)
      if part2, do: hd(l) - get_next(diffs, part2), else: get_next(diffs, part2) + List.last(l)
    end
  end

  def solve(input, part2 \\ false) do
    input
    |> Enum.map(& get_next(&1, part2))
    |> Enum.sum()
  end

  def part1(input), do: solve(input)
  def part2(input), do: solve(input, part2: true)

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_09.main()
