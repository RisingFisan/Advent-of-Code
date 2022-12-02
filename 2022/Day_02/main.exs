defmodule Day_02 do
  @values %{
    "X" => 1,
    "Y" => 2,
    "Z" => 3
  }

  @winning_moves %{
    "A" => "Y",
    "B" => "Z",
    "C" => "X"
  }

  @tying_moves %{
    "A" => "X",
    "B" => "Y",
    "C" => "Z"
  }

  @losing_moves %{
    "A" => "Z",
    "B" => "X",
    "C" => "Y"
  }

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(& String.split(&1, " ", trim: true) |> List.to_tuple)
  end

  def part1(input) do
    Enum.reduce(input, 0, fn {a,b}, acc ->
      cond do
        @winning_moves[a] == b -> 6
        @tying_moves[a] == b -> 3
        true -> 0
      end + @values[b] + acc
    end)
  end

  def part2(input) do
    Enum.reduce(input, 0, fn {a,b}, acc ->
      case b do
        "X" -> @values[@losing_moves[a]]
        "Y" -> 3 + @values[@tying_moves[a]]
        "Z" -> 6 + @values[@winning_moves[a]]
      end + acc
    end)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_02.main
