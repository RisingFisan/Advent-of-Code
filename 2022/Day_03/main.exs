defmodule Day_03 do
  @priorities (Enum.zip(Enum.concat(?a..?z, ?A..?Z), 1..52)
    |> Map.new)

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  def part1(input) do
    input
    |> Enum.map(fn rucksack ->
      {compart1, compart2} = Enum.split(rucksack, div(length(rucksack), 2))
      MapSet.intersection(MapSet.new(compart1), MapSet.new(compart2))
      |> Enum.fetch!(0)
      |> then(& @priorities[&1])
    end)
    |> Enum.sum
  end

  def part2(input) do
    input
    |> Enum.chunk_every(3)
    |> Enum.map(fn s -> Enum.map(s, &MapSet.new/1) end)
    |> Enum.map(fn [sack1, sack2, sack3] ->
      MapSet.intersection(sack1, sack2)
      |> MapSet.intersection(sack3)
      |> Enum.fetch!(0)
      |> then(& @priorities[&1])
    end)
    |> Enum.sum
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

IO.inspect(:timer.tc(Day_03, :main, []) |> elem(0), label: "Time (uSecs)")
