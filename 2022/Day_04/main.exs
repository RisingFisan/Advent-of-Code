defmodule Day_04 do

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.run(~r/(\d+)-(\d+),(\d+)-(\d+)/, line)
      |> tl
      |> Enum.map(&String.to_integer/1)
      |> then(fn [elf1_i, elf1_f, elf2_i, elf2_f] ->
        {MapSet.new(elf1_i..elf1_f), MapSet.new(elf2_i..elf2_f)}
      end)
    end)
  end

  def part1(input) do
    input
    |> Enum.reduce(0, fn {elf1, elf2}, acc ->
      if MapSet.subset?(elf1, elf2) or MapSet.subset?(elf2, elf1) do
        acc + 1
      else
        acc
      end
    end)
  end

  def part2(input) do
    input
    |> Enum.reduce(0, fn {elf1, elf2}, acc ->
      if MapSet.intersection(elf1, elf2) |> MapSet.size > 0 do
        acc + 1
      else
        acc
      end
    end)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_04.main
