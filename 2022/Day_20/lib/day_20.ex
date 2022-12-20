defmodule Day_20 do

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(Stream.iterate(0, &(&1 + 1)))
  end

  def part1(input) do
    new_list = Enum.reduce(input, input, fn v, acc ->
      i = Enum.find_index(acc, fn x -> x == v end)
      {{n,v}, rest} = List.pop_at(acc, i)
      List.insert_at(rest, Integer.mod(i + n, length(input) - 1), {n,v})
    end)
    i = Enum.find_index(new_list, &(elem(&1,0) == 0))
    Enum.sum([
      Enum.at(new_list, Integer.mod(i + 1000, length(new_list))) |> elem(0),
      Enum.at(new_list, Integer.mod(i + 2000, length(new_list))) |> elem(0),
      Enum.at(new_list, Integer.mod(i + 3000, length(new_list))) |> elem(0)
    ])
  end

  def part2(input) do
    new_input = input |> Enum.map(fn {k,v} -> {k * 811589153, v} end)
    new_list = Enum.reduce(List.duplicate(new_input, 10) |> Enum.concat, new_input, fn v, acc ->
      i = Enum.find_index(acc, fn x -> v == x end)
      {{n,v}, rest} = List.pop_at(acc, i)
      List.insert_at(rest, Integer.mod(i + n, length(input) - 1), {n,v})
    end)
    i = Enum.find_index(new_list, &(elem(&1,0) == 0))
    Enum.sum([
      Enum.at(new_list, Integer.mod(i + 1000, length(new_list))) |> elem(0),
      Enum.at(new_list, Integer.mod(i + 2000, length(new_list))) |> elem(0),
      Enum.at(new_list, Integer.mod(i + 3000, length(new_list))) |> elem(0)
    ])
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end
