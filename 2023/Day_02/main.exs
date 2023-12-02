Mix.install([:nimble_parsec])

defmodule MyParser do
  import NimbleParsec

  def reduce_cube([number, color]) do
    {color, number}
  end

  def reduce_cubes(cubes) do
    Enum.group_by(cubes, & elem(&1, 0), & elem(&1, 1))
    |> Map.new(fn {color, vals} -> {color, Enum.max(vals)} end)
  end

  cube =
    integer(min: 1)
    |> ignore(string(" "))
    |> choice([
      string("blue") |> replace(:blue),
      string("green") |> replace(:green),
      string("red") |> replace(:red)
    ])
    |> reduce(:reduce_cube)

  cubes =
    cube
    |> repeat(
      ignore(choice([string(", "), string("; ")]))
      |> concat(cube)
    )
    |> reduce(:reduce_cubes)

  defparsec :cubes, cubes
end

defmodule Day_02 do
  @limits %{
    blue: 14,
    green: 13,
    red: 12
  }

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, i, cubes] = Regex.run(~r/Game (\d+): (.*)/, line)
      [parsed_cubes] = MyParser.cubes(cubes) |> elem(1)
      {String.to_integer(i), parsed_cubes}
      # |> String.split(";")
      # |> Enum.map(&parse_cubes/1)
      # |> Enum.concat()
      # |> Enum.group_by(& elem(&1, 0), & elem(&1, 1))
      # |> Map.new(fn {color, vals} -> {color, Enum.max(vals)} end)}
    end)
  end

  # def parse_cubes(str) do
  #   str
  #   |> String.split(",")
  #   |> Enum.map(fn set ->
  #     [_, number, color] = Regex.run(~r/\s*(\d+) (\w+)/, set)
  #     {String.to_atom(color), String.to_integer(number)}
  #   end)
  # end

  def part1(input) do
    input
    |> Enum.reduce(0, fn {i, game}, acc ->
      if Map.get(game, :blue, 0) > @limits[:blue] or
        Map.get(game, :green, 0) > @limits[:green] or
        Map.get(game, :red, 0) > @limits[:red], do: acc, else: acc + i
    end)
  end

  def part2(input) do
    input
    |> Enum.reduce(0, fn {_i, game}, acc ->
      acc + Enum.product(Map.values(game))
    end)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")

  end
end

Day_02.main()
