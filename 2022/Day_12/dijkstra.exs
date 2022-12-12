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
    %{grid: grid, cur: nil, dists: nil, unvisited: nodes, parents: Map.new()}
  end

  def run(s, start_value, end_value) do
    start = Enum.with_index(s.grid)
    |> Enum.find_value(fn {line,i} ->
      x = Enum.find_index(line, & &1 == start_value)
      if x, do: {x,i}
    end)
    output = dijkstra(%{s | cur: start, dists: Map.new([{start, 0}]), unvisited: MapSet.delete(s.unvisited, start)}, end_value)
    get_path(output.cur, start, output.parents) |> length
  end

  def dijkstra(s = %{unvisited: u}, _end_value) when length(u) == 0, do: s
  def dijkstra(s = %{grid: grid, cur: {x,y}, dists: dists, unvisited: unvisited, parents: parents}, end_value) do
    {cur_value, is_end} = case Enum.at(grid, y) |> Enum.at(x) do
      ?S -> {?a, ?a == end_value}
      ?E -> {?z, ?E == end_value}
      a -> {a, a == end_value}
    end

    if is_end do
      s
    else
      cur_dist = Map.get(dists, {x,y})
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

      {new_dists, new_parents} = for neighbor <- neighbors, reduce: {dists, parents} do
        {acc_d, acc_p} ->
          if Map.get(acc_d, neighbor, 10000) <= cur_dist + 1 do
            {acc_d, acc_p}
          else
            {
              Map.put(acc_d, neighbor, cur_dist + 1),
              Map.put(acc_p, neighbor, {x,y})
            }
          end
      end
      next_node = Enum.min_by(unvisited, & Map.get(new_dists, &1, 10000))
      dijkstra(%{s | cur: next_node, dists: new_dists, unvisited: MapSet.delete(unvisited, next_node), parents: new_parents}, end_value)
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
