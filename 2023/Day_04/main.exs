defmodule Day_04 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, winning, personal] = Regex.run(~r/Card\s+\d+\: ([\d\s]+) \| ([\d\s]+)/, line)
      winning
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> MapSet.new()
      |> MapSet.intersection(
        personal
        |> String.split()
        |> Enum.map(&String.to_integer/1)
        |> MapSet.new()
      )
      |> MapSet.size()
    end)
  end

  def part1(input) do
    Enum.reduce(input, 0, fn
      0, acc -> acc
      n, acc -> acc + 2 ** (n - 1)
    end)
  end

  def part2(input) do
    input
    |> Stream.iterate(&tl/1)
    |> Stream.take_while(& length(&1) > 0) # tails
    |> Stream.map(&count/1)
    |> Enum.sum()
  end

  def count([]), do: 0
  def count([ 0 | _ ]), do: 1
  def count([ h | t ]) do
    for i <- 0..(h-1) do
      count(Enum.drop(t, i))
    end
    |> Enum.sum()
    |> Kernel.+(1)
  end

  def part2v2(input) do
    Enum.reduce(input, {%{}, 0}, fn n, {acc, r} ->
      x = Enum.sum(Map.values(acc)) + 1
      new_acc = Enum.filter(acc, fn {k,_v} -> k > 1 end) |> Map.new(fn {k,v} -> {k-1,v} end)
      if n > 0 do
        {new_acc |> Map.update(n, x, & &1 + x), r + x }
      else
        {new_acc, r + x }
      end
    end)
    |> elem(1)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2v2(parsed_input), label: "Part 2")
  end
end

Day_04.main()
