defmodule Day_11 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(& String.to_charlist(&1))
  end

  def combinations([]), do: []
  def combinations([h | t]) do
    Enum.map(t, & {h, &1})
    |> Enum.concat(combinations(t))
  end

  def expand(points, galaxy, n) do
    r = n - 1
    max_y = length(galaxy) - 1
    max_x = length(Enum.at(galaxy, 0)) - 1

    {new_points, _} = for y <- 0..max_y, reduce: {points, 0} do
      {acc, counter} -> if Enum.at(galaxy, y) |> Enum.any?(& &1 == ?#) do
        {acc, counter}
      else
        {Enum.map(acc, fn {xp, yp} -> if yp > (y + r * counter), do: {xp, yp + r}, else: {xp, yp} end), counter + 1}
      end
    end
    for x <- 0..max_x, reduce: {new_points, 0} do
      {acc, counter} -> if Enum.map(galaxy, & Enum.at(&1, x)) |> Enum.any?(& &1 == ?#) do
        {acc, counter}
      else
        {Enum.map(acc, fn {xp, yp} -> if xp > (x + r * counter), do: {xp + r, yp}, else: {xp, yp} end), counter + 1}
      end
    end |> elem(0)
  end

  def solve(input, n) do
    input
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, y}, acc ->
      Enum.reduce(line, [], fn {spot, x}, acc ->
        if spot == ?#, do: [x | acc], else: acc
      end)
      |> Enum.map(& {&1, y})
      |> Enum.concat(acc)
    end)
    |> expand(input, n)
    |> combinations()
    |> Enum.map(fn {{x1,y1}, {x2,y2}} -> abs(x1 - x2) + abs(y1 - y2) end)
    |> Enum.sum()
  end

  def part1(input), do: solve(input, 2)
  def part2(input), do: solve(input, 1_000_000)

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_11.main()
