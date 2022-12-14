defmodule Day_14 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " -> ", trim: true)
      |> Enum.map(fn pair ->
        String.split(pair,",", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple
      end)
      |> Enum.chunk_every(2, 1, :discard)
    end)
    |> Enum.concat
    |> Enum.reduce(%{grid: %{}}, fn [{x1,y1},{x2,y2}], acc ->
      for y <- y1..y2, reduce: acc do
        acc -> for x <- x1..x2, reduce: acc do
          acc ->
            %{acc | grid: Map.put(acc.grid, {x,y}, :R)}
            |> Map.update(:min_x, x, fn min_x -> min(min_x, x) end)
            |> Map.update(:max_x, x, fn max_x -> max(max_x, x) end)
            |> Map.update(:max_y, y, fn max_y -> max(max_y, y) end)
        end
      end
    end)
  end

  def sim_sand(s, {x,y}, part1) do
    if part1 and (x < s.min_x or x > s.max_x or y > s.max_y) do
      {:stop, s}
    else
      cond do
        s.grid[{x,y+1}] == nil and (part1 or y+1 < s.max_y + 2) -> sim_sand(s, {x,y+1}, part1)
        s.grid[{x-1,y+1}] == nil and (part1 or y+1 < s.max_y + 2) -> sim_sand(s, {x-1,y+1}, part1)
        s.grid[{x+1,y+1}] == nil and (part1 or y+1 < s.max_y + 2) -> sim_sand(s, {x+1,y+1}, part1)
        true -> {(if {x,y} == {500,0}, do: :stop, else: :ok), %{s | grid: Map.put(s.grid, {x,y}, :S)}}
      end
    end
  end

  def part1(input) do
    Enum.reduce_while(Stream.iterate(1, & &1+1), input, fn i, s ->
      case sim_sand(s, {500,0}, true) do
        {:ok, new_s} -> {:cont, new_s}
        {:stop, new_s} -> {:halt, Map.put(new_s, :grains, i - 1)}
      end
    end)
    |> pretty_print(true)
    |> Map.get(:grains)
  end

  def part2(input) do
    Enum.reduce_while(Stream.iterate(1, & &1+1), input, fn i, s ->
      case sim_sand(s, {500,0}, false) do
        {:ok, new_s} -> {:cont, new_s}
        {:stop, new_s} -> {:halt, Map.put(new_s, :grains, i)}
      end
    end)
    |> pretty_print(false)
    |> Map.get(:grains)
  end

  def pretty_print(s, part1) do
    {min_x,max_x} = if part1, do: {s.min_x,s.max_x}, else: Map.keys(s.grid) |> Enum.map(&elem(&1,0)) |> Enum.min_max()
    for y <- 0..(if part1, do: s.max_y, else: s.max_y+2) do
      for x <- min_x..max_x do
        if y == s.max_y + 2 do
          IO.write("#")
        else
          IO.write(case s.grid[{x,y}] do
            :R -> "#"
            :S -> "o"
            _ -> " "
          end)
        end
      end
      IO.puts("")
    end
    s
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end
