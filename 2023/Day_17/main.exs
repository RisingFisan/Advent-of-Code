defmodule Day_17 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.to_charlist(line)
      |> Enum.map(& &1 - ?0)
    end)
    |> then(fn map ->
      %{
        map: map,
        height: length(map) - 1,
        width: length(Enum.at(map, 0)) - 1
      }
    end)
  end

  def shortest_path(map, queue, parents, dists, visited, max_d) do
    if MapSet.size(queue) == 0 do
      {parents,dists}
    else
      {x,y,dir,n} = Enum.min_by(queue, fn p -> Map.get(dists, p) end)

      if {x,y} == {map.width, map.height} and n <= 6 do
        {parents,dists}
      else

      dist = Map.get(dists, {x,y,dir,n})

      next_nodes = case dir do
        :U ->
          r = [{x-1,y,:L,max_d}, {x+1,y,:R,max_d}]
          if n == 0, do: r, else: (if n <= 6, do: [ {x,y-1,:U,n-1} | r], else: [{x,y-1,:U,n-1}])
        :D ->
          r = [{x-1,y,:L,max_d}, {x+1,y,:R,max_d}]
          if n == 0, do: r, else: (if n <= 6, do: [ {x,y+1,:D,n-1} | r], else: [{x,y+1,:D,n-1}])
        :L ->
          r = [{x,y-1,:U,max_d}, {x,y+1,:D,max_d}]
          if n == 0, do: r, else: (if n <= 6, do: [ {x-1,y,:L,n-1} | r], else: [{x-1,y,:L,n-1}])
        :R ->
          r = [{x,y-1,:U,max_d}, {x,y+1,:D,max_d}]
          if n == 0, do: r, else: (if n <= 6, do: [ {x+1,y,:R,n-1} | r], else: [{x+1,y,:R,n-1}])
        _ -> [{x,y-1,:U,max_d}, {x,y+1,:D,max_d}, {x-1,y,:L,max_d}, {x+1,y,:R,max_d}]
      end
      |> Enum.filter(fn {xx,yy,dd,nn} ->
        xx in 0..map.width and
        yy in 0..map.height and
        {xx,yy,dd,nn} not in visited
      end)

      {new_parents, new_dists} = Enum.reduce(next_nodes, {parents, dists}, fn {xx,yy,dd,nn}, {prts, dsts} ->
        dst = dist + (Enum.at(map.map, yy) |> Enum.at(xx))
        if not Map.has_key?(dsts, {xx,yy,dd,nn}) or (Map.get(dsts, {xx,yy,dd,nn}) > dst) do
          {Map.put(prts, {xx,yy,dd,nn}, {x,y,dir,n}), Map.put(dsts, {xx,yy,dd,nn}, dst)}
        else
          {prts, dsts}
        end
      end)

      new_queue =
        queue
        |> MapSet.delete({x,y,dir,n})
        |> MapSet.union(MapSet.new(next_nodes))

      new_visited = MapSet.put(visited, {x,y,dir,n})

      shortest_path(map, new_queue, new_parents, new_dists, new_visited, max_d)
      end
    end
  end

  def part1(map) do
    {_parents, dists} = shortest_path(map, MapSet.new([{0,0,:X,3}]), %{}, %{{0,0,:X,3} => 0}, MapSet.new(), 2)

    (for {{x,y,_,_}, dist} <- dists, x == map.width, y == map.height, do: dist)
    |> Enum.min()
  end


  def part2(map) do
    {_parents, dists} = shortest_path(map, MapSet.new([{0,0,:X,10}]), %{}, %{{0,0,:X,10} => 0}, MapSet.new(), 9)

    (for {{x,y,_,n}, dist} <- dists, x == map.width, y == map.height, n <= 6, do: dist)
    |> Enum.min()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1", limit: :infinity)
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_17.main()
