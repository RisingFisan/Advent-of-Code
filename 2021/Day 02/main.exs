defmodule Day02 do
  @position 0
  @depth 0
  @aim 0

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Stream.map(fn element ->
      Regex.named_captures(~r/(?<direction>\w+) (?<value>\d+)/, element)
    end)
    |> Stream.map(fn %{"direction" => dir, "value" => val} ->
      %{direction: dir, value: String.to_integer(val)}
    end)
    |> Enum.to_list()
  end

  def part1(filename) do
    parse_input(filename)
    |> Enum.reduce({@position, @depth}, fn element, {position, depth} ->
      case element.direction do
        "forward" -> {position + element.value, depth}
        "down" -> {position, depth + element.value}
        "up" -> {position, depth - element.value}
      end
    end)
    |> then(fn {a,b} -> a * b end)
  end

  def part2(filename) do
    parse_input(filename)
    |> Enum.reduce({@position, @depth, @aim}, fn element, {position, depth, aim} ->
      case element.direction do
        "forward" -> {position + element.value, depth + (aim * element.value), aim}
        "down" -> {position, depth, aim + element.value}
        "up" -> {position, depth, aim - element.value}
      end
    end)
    |> then(fn {a,b,_} -> a * b end)
  end
end

IO.inspect(Day02.part1("input"), label: "Part 1")
IO.inspect(Day02.part2("input"), label: "Part 2")
