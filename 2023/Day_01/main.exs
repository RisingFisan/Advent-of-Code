defmodule Day_01 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
  end

  def part1(input) do
    input
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(fn line -> Enum.filter(line, & &1 in ?0 .. ?9) end)
    |> Stream.map(& << hd(&1), List.last(&1)>>)
    |> Stream.map(& String.to_integer/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Stream.map(fn line ->
      Stream.unfold(line, fn
        "" -> nil
        line -> {line, String.slice(line, 1..-1)}
      end)
      |> Stream.map(& Regex.run(~r/\d|one|two|three|four|five|six|seven|eight|nine/, &1))
      |> Stream.filter(& &1 != nil)
      |> Stream.concat()
      |> Enum.map(fn digit ->
        Map.get(%{
          "one" => "1",
          "two" => "2",
          "three" => "3",
          "four" => "4",
          "five" => "5",
          "six" => "6",
          "seven" => "7",
          "eight" => "8",
          "nine" => "9"}, digit, digit)
        end)
      end)
    |> Stream.map(& hd(&1) <> List.last(&1))
    |> Stream.map(& String.to_integer/1)
    |> Enum.sum()
  end

  # Inspired from a Reddit comment, wrote it after finishing
  def part2v2(input) do
    numbers = "one|two|three|four|five|six|seven|eight|nine"
    first_re = Regex.compile!("\\d|#{numbers}")
    last_re = Regex.compile!("\\d|#{numbers |> String.reverse()}")
    number_mapper = fn x -> Map.get(%{
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"}, x, x) end

    input
    |> Stream.map(fn line ->
      (Regex.run(first_re, line) |> hd() |> number_mapper.())
      <> (Regex.run(last_re, line |> String.reverse()) |> hd() |> String.reverse() |> number_mapper.())
    end)
    |> Stream.map(& String.to_integer/1)
    |> Enum.sum()
  end

  def part2v3(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.replace("one", "o1e")
      |> String.replace("two", "t2o")
      |> String.replace("three", "th3ee")
      |> String.replace("four", "f4ur")
      |> String.replace("five", "f5ve")
      |> String.replace("six", "s6x")
      |> String.replace("seven", "se7en")
      |> String.replace("eight", "ei8ht")
      |> String.replace("nine", "ni9e")
      end)
    |> part1()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2v3(parsed_input), label: "Part 2")
  end
end

Day_01.main()
