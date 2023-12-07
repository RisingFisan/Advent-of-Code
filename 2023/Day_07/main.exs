defmodule Day_07 do

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line)
      |> then(fn [hand, bid] ->
        {String.to_charlist(hand), String.to_integer(bid)}
      end)
    end)
  end

  def get_hand_type(hand, part2) do
    js = Enum.count(hand, & &1 == ?J)
    hand
    |> then(fn xs -> if part2, do: Enum.filter(xs, & &1 != ?J), else: xs end)
    |> Enum.sort()
    |> Enum.chunk_by(& &1)
    |> Enum.map(& length(&1))
    |> Enum.sort()
    |> then(fn xs -> if part2, do: List.update_at(xs, -1, & &1 + js), else: xs end)
    |> case do
      [5] -> 1
      [1,4] -> 2
      [2,3] -> 3
      [1,1,3] -> 4
      [1,2,2] -> 5
      [1,1,1,2] -> 6
      [1,1,1,1,1] -> 7
      [] -> 1
      err -> throw "HUH?! '#{err}'"
    end
  end

  def map_hand(hand, part2) do
    Enum.map(hand, fn
      ?A -> 1
      ?K -> 2
      ?Q -> 3
      ?J -> (if part2, do: 1000, else: 4)
      ?T -> 5
      n -> ?0 - n + 15
    end)
  end

  def calculate(input, part2 \\ false) do
    input
    |> Enum.sort_by(fn {hand,_bid} -> {get_hand_type(hand, part2), map_hand(hand, part2)} end, :desc)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_hand, bid}, i}, acc ->
      acc + i * bid
    end)
  end

  def part1(input) do
    calculate(input)
  end

  def part2(input) do
    calculate(input, part2: true)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_07.main()
