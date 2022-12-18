defmodule Day_18 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, ",", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)
    |> MapSet.new
  end

  def part1(input) do
    input
    |> Enum.reduce(0, fn {x,y,z}, covered ->
      covered + Enum.reduce([
        {x+1,y,z},
        {x-1,y,z},
        {x,y+1,z},
        {x,y-1,z},
        {x,y,z+1},
        {x,y,z-1}
      ], 0, fn point, cov -> if MapSet.member?(input, point), do: cov + 1, else: cov end)
    end)
    |> (&(MapSet.size(input) * 6 - &1)).()
  end

  def part2(input) do
    bounds = Enum.reduce(input, %{min_x: :infinity, max_x: 0, min_y: :infinity, max_y: 0, min_z: :infinity, max_z: 0}, fn {x,y,z}, acc ->
      %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y, min_z: min_z, max_z: max_z} = acc
      %{
        min_x: (if x < min_x, do: x, else: min_x),
        max_x: (if x > max_x, do: x, else: max_x),
        min_y: (if y < min_y, do: y, else: min_y),
        max_y: (if y > max_y, do: y, else: max_y),
        min_z: (if z < min_z, do: z, else: min_z),
        max_z: (if z > max_z, do: z, else: max_z)
      }
    end)

    # pretty_print(input, bounds)

    Enum.reduce(input, 0, fn {x,y,z}, covered ->
      covered + Enum.reduce([
        {x+1,y,z},
        {x-1,y,z},
        {x,y+1,z},
        {x,y-1,z},
        {x,y,z+1},
        {x,y,z-1}
      ], 0, fn point, cov ->
        cov + if in_exterior?(point, input, bounds), do: 0, else: 1
      end)
    end)
    |> (&(MapSet.size(input) * 6 - &1)).()
  end

  def in_exterior?(point, points, bounds) do
    not MapSet.member?(points, point) and bfs(point, points, bounds)
  end

  def bfs(start, points, bounds) do
    queue = [start]
    visited = MapSet.new(points) |> MapSet.put(start)

    Enum.reduce_while(Stream.iterate(1, & &1 + 1), {queue, visited}, fn _i, {queue, visited} ->
      case queue do
        [] -> {:halt, false}
        [ current | queue ] ->
          {x,y,z} = current
          neighbors = [
            {x+1,y,z},
            {x-1,y,z},
            {x,y+1,z},
            {x,y-1,z},
            {x,y,z+1},
            {x,y,z-1}
          ] |> Enum.filter(& !MapSet.member?(visited, &1))
          if Enum.any?(neighbors, &outside_bounds(&1, bounds)) do
            {:halt, true}
          else
            new_queue = queue ++ neighbors
            new_visited = MapSet.union(visited, MapSet.new(neighbors))
            {:cont, {new_queue, new_visited}}
          end
      end
    end)
  end

  def outside_bounds({x,y,z}, bounds) do
    x < bounds.min_x or x > bounds.max_x or y < bounds.min_y or y > bounds.max_y or z < bounds.min_z or z > bounds.max_z
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end

  def pretty_print(points, bounds) do
    for z <- bounds.min_z..bounds.max_z do
      for x <- bounds.min_x..bounds.max_x do
        for y <- bounds.min_y..bounds.max_y do
          if MapSet.member?(points, {x,y,z}) do
            IO.write("#")
          else
            IO.write(".")
          end
        end
        IO.puts("")
      end
      IO.puts("\n\n")
    end
  end
end
