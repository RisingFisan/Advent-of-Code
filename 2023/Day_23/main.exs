defmodule Day_23 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(& String.to_charlist/1)
    |> then(fn map ->
      tiles = map
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {line, y}, acc ->
          line
          |> Enum.with_index()
          |> Map.new(fn {tile, x} -> {{x,y}, tile} end)
          |> Map.merge(acc)
        end)
      %{
        tiles: tiles,
        height: length(map),
        width: length(Enum.at(map, 0))
      }
    end)
  end

  def dfs(map, {x,y}, visited) do
    if {x,y} == {map.width - 2, map.height - 1} do
      MapSet.size(visited)
    else
      neighbors = case Map.get(map.tiles, {x,y}) do
        nil -> []
        ?v -> [{x,y+1}]
        ?^ -> [{x,y-1}]
        ?< -> [{x-1,y}]
        ?> -> [{x+1,y}]
        ?. -> [
          {x,y+1},
          {x,y-1},
          {x-1,y},
          {x+1,y}
        ]
      end
      |> Enum.filter(fn {xx,yy} ->
        Map.get(map.tiles, {xx,yy}, ?#) != ?# and
        {xx,yy} not in visited
      end)

      if length(neighbors) == 0 do
        nil
      else
        new_visited = MapSet.put(visited, {x,y})
        Enum.map(neighbors, & dfs(map, &1, new_visited))
        |> Enum.filter(& &1 != nil)
        |> Enum.max()
      end
    end
  end

  def bifurcation_graph(map, p, origin, pid) do
    if Agent.get(pid, fn cache -> MapSet.member?(cache, p) end) do
      %{}
    else
      {dist, point, neighbors} = Enum.reduce_while(Stream.iterate(1, & &1 + 1), {p, origin}, fn i, {{x,y}, prev} ->
        if {x,y} == {map.width - 2, map.height - 1} do
          {:halt, {i, {x,y}, []}}
        else
          neighbors = case Map.get(map.tiles, {x,y}) do
            nil -> []
            _ -> [
              {x,y+1},
              {x,y-1},
              {x-1,y},
              {x+1,y}
            ]
          end
          |> Enum.filter(fn {xx,yy} ->
            Map.get(map.tiles, {xx,yy}, ?#) != ?# and
            {xx,yy} != prev
          end)

          if length(neighbors) == 1 do
            {:cont, {hd(neighbors), {x,y}}}
          else
            {:halt, {i, {x,y}, neighbors}}
          end
        end
      end)

      Agent.update(pid, fn cache -> MapSet.put(cache, p) end)

      for neighbor <- neighbors, reduce: %{origin => MapSet.new([{point, dist}])} do
        acc -> bifurcation_graph(map, neighbor, point, pid) |> Map.merge(acc, fn _k, v1, v2 -> MapSet.union(v1, v2) end)
      end
    end
  end

  def dfs2(graph, {x,y}, visited) do
    if {x,y} == {graph.width - 2, graph.height - 1} do
      0
    else
      neighbors =
        Map.get(graph, {x,y})
        |> Enum.filter(fn {pos, _} -> pos not in visited end)

      new_visited = MapSet.put(visited, {x,y})

      Enum.map(neighbors, fn {pos, dist} ->
        v = dfs2(graph, pos, new_visited)
        if v != nil, do: v + dist, else: nil
       end)
      |> Enum.filter(& &1 != nil)
      |> Enum.max(fn -> nil end)
    end
  end

  def part1(input) do
    dfs(input, {1,0}, MapSet.new())
  end

  def part2(input) do
    {:ok, pid} = Agent.start_link(fn -> MapSet.new() end)

    input
    |> bifurcation_graph({1,1}, {1,0}, pid)
    |> Map.put(:width, input.width)
    |> Map.put(:height, input.height)
    |> dfs2({1,0}, MapSet.new())
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_23.main()
