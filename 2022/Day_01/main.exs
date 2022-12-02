defmodule Day_01 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn elf ->
      String.split(elf, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1(input) do
    input
    |> Enum.map(&Enum.sum/1)
    |> Enum.max
  end

  def part2(input) do
    input
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)
    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_01.main
