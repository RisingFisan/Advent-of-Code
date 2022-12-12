defmodule Day_12 do
  def parse_input(filename) do
    grid = File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    nodes = for y <- 0..length(grid) - 1 do
      for x <- 0..length(Enum.at(grid,0)) - 1 do
        {x,y}
      end
    end
    |> Enum.concat
    |> MapSet.new
    %{grid: grid, queue: nil, unvisited: nodes, parents: Map.new()}
  end

  def run(s, start_value, end_value) do
    start = Enum.with_index(s.grid)
    |> Enum.find_value(fn {line,i} ->
      x = Enum.find_index(line, & &1 == start_value)
      if x, do: {x,i}
    end)
    output = bfs(%{s | queue: [start], unvisited: MapSet.delete(s.unvisited, start)}, end_value)
    get_path(hd(output.queue), start, output.parents) |> length
  end

  def bfs(s = %{grid: grid, queue: [ {x,y} | t ], unvisited: unvisited, parents: parents}, end_value) do
    {cur_value, is_end} = case Enum.at(grid, y) |> Enum.at(x) do
      ?S -> {?a, ?a == end_value}
      ?E -> {?z, ?E == end_value}
      a -> {a, a == end_value}
    end

    if is_end do
      s
    else
      neighbors = Enum.filter([{x-1,y},{x+1,y},{x,y-1},{x,y+1}], fn {nx,ny} ->
        {nx,ny} in unvisited
      end)
      |> Enum.filter(fn {nx,ny} ->
        n_value = case Enum.at(grid, ny) |> Enum.at(nx) do
          ?S -> ?a
          ?E -> ?z
          a -> a
        end
        if end_value == ?E, do: n_value <= cur_value + 1, else: n_value >= cur_value - 1
      end)

      new_parents = Enum.reduce(neighbors, parents, & Map.put(&2, &1, {x,y}))
      bfs(%{s | queue: Enum.concat(t, neighbors), unvisited: MapSet.difference(unvisited, MapSet.new(neighbors)), parents: new_parents}, end_value)
    end
  end

  def get_path(pi, pf, nexts) do
    if pi == pf do
      []
    else
      [ pi | get_path(Map.get(nexts, pi), pf, nexts) ]
    end
  end

  def part1(input) do
    run(input, ?S, ?E)
  end

  def part2(input) do
    run(input, ?E, ?a)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_12.main
