defmodule Day_21 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  def get_starting_position(map) do
    width = length(Enum.at(map, 0))
    height = length(map)
    {map, st_pos} = map
    |> Enum.with_index()
    |> List.foldr({%{}, nil}, fn {line, y}, {map, st_pos} ->
      {line, st_x} = line
        |> Enum.with_index()
        |> List.foldr({%{},nil}, fn {elem, x}, {line, st_x} ->
          if elem == ?S do
            {Map.put(line, {x,y}, ?.), x}
          else
            {Map.put(line, {x,y}, elem), st_x}
          end
        end)
      if st_x == nil do
        {Map.merge(line, map), st_pos}
      else
        {Map.merge(line, map), {st_x, y}}
      end
    end)
    {%{
      width: width,
      height: height,
      tiles: map
    }, st_pos}
  end

  def part1({map, starting_position}) do
    steps = 64
    Enum.reduce_while(Stream.iterate(0, & &1 + 1), {MapSet.new([starting_position]), {:a,:b,:c}}, fn i, {queue, {prev1, prev2, prev3}} ->
      cond do
        i == steps -> {:halt, MapSet.size(queue)}
        prev1 == prev3 -> {:halt, (if rem(steps, 2) == rem(i, 2), do: prev1, else: prev2)}
        true ->
          new_queue = queue
          |> Enum.map(fn {x,y} ->
            [
              {x+1,y},
              {x-1,y},
              {x,y-1},
              {x,y+1}
            ]
            |> Enum.filter(fn {xx,yy} ->
              Map.get(map.tiles, {xx, yy}, ?#) != ?#
            end)
          end)
          |> Enum.concat()
          |> MapSet.new()
          {:cont, {new_queue, {MapSet.size(new_queue), prev1, prev2}}}
      end
    end)
  end

  def part2({map, starting_position}) do
    difference = map.height
    goal = 26501365
    steps = difference * 5
    totals = Enum.reduce_while(Stream.iterate(0, & &1 + 1), {MapSet.new([starting_position]), %{odds: MapSet.new(), evens: MapSet.new()}, %{evens: 0, odds: 0}, []}, fn i, {queue, prev, total, prev_totals} ->
      current_total = (if rem(i,2) == 0, do: MapSet.size(prev.evens) + total.evens, else: MapSet.size(prev.odds) + total.odds) + MapSet.size(queue)
      cond do
        i == steps -> {:halt, [ current_total | prev_totals ]}
        true ->
          new_queue = queue
          |> Enum.map(fn {x,y} ->
            [
              {x+1,y},
              {x-1,y},
              {x,y-1},
              {x,y+1}
            ]
            |> Enum.filter(fn {xx,yy} ->
              Map.get(map.tiles, {Integer.mod(xx, map.width), Integer.mod(yy, map.height)}) != ?#
            end)
          end)
          |> Enum.concat()
          |> MapSet.new()

          new_prev = if rem(i,2) == 0 do
            %{prev | evens: queue}
          else
            %{prev | odds: queue}
          end

          new_total = if rem(i,2) == 0 do
            %{total | evens: total.evens + MapSet.size(prev.evens)}
          else
            %{total | odds: total.odds + MapSet.size(prev.odds)}
          end

          new_new_queue = if rem(i,2) == 0 do
            MapSet.difference(new_queue, prev.odds)
          else
            MapSet.difference(new_queue, prev.evens)
          end

          {:cont, {new_new_queue, new_prev, new_total, [current_total | prev_totals]}}
      end
    end)

    # difference = totals
    # |> Enum.take(steps - 10)
    # |> Enum.chunk_every(2, 1, :discard)
    # |> Enum.map(fn [a,b] -> a - b end)
    # |> then(fn chunks ->
    #   Enum.reduce_while(Stream.iterate(1, & &1 + 1), nil, fn i, _ ->
    #     [h | t] = Enum.chunk_every(chunks, i, i, :discard)
    #     |> Enum.map(&Enum.sum/1)
    #     |> Enum.chunk_every(2, 1, :discard)
    #     |> Enum.map(fn [a,b] -> a - b end)

    #     if Enum.all?(t, & &1 == h), do: {:halt, i}, else: {:cont, nil}
    #   end)
    # end)

    # I did all this just to get the map height as the value 🗿

    offset = rem(goal, difference)
    offset2 = rem(steps, difference)

    offsetX = Integer.mod(offset2 - offset, difference)

    [a,b,c | _] = totals
    |> Enum.drop(offsetX)
    |> Enum.take_every(difference)

    factor = (a - b) - (b - c)

    Enum.reduce(1..div(goal-steps+offsetX, difference), {a,b}, fn _, {a,b} ->
      diff = a - b
      {a + factor + diff, a}
    end)
    |> elem(0)
  end

  # def part2({map, starting_position}, n) do
  #   steps = 10 - n
  #   Enum.reduce_while(Stream.iterate(0, & &1 + 1), %{
  #     queue: [{starting_position, 0}],
  #     visited: MapSet.new(),
  #     total: 0
  #   }, fn _, acc ->
  #     if length(acc.queue) == 0 do
  #       {:halt, acc.total}
  #     else
  #       [ {st_pos, st} | rest_queue ] = acc.queue
  #       {r, others} = Enum.reduce_while(Stream.iterate(st, & &1 + 1), {MapSet.new([st_pos]), {:a, :b, :c}, MapSet.new()}, fn i, {queue, {prev1, prev2, prev3}, others} ->
  #         cond do
  #           i == steps -> {:halt, {MapSet.size(queue), others}}
  #           prev1 == prev3 -> {:halt, {(if rem(steps, 2) == rem(i, 2), do: prev1, else: prev2), others}}
  #           true ->
  #             new_queue = queue
  #             |> Enum.map(fn {x,y} ->
  #               [
  #                 {x+1,y},
  #                 {x-1,y},
  #                 {x,y-1},
  #                 {x,y+1}
  #               ]
  #               |> Enum.filter(fn {xx,yy} ->
  #                 Map.get(map.tiles, {Integer.mod(xx, map.width), Integer.mod(yy, map.height)}) != ?#
  #               end)
  #             end)
  #             |> Enum.concat()
  #             |> MapSet.new()

  #             new_others = new_queue
  #             |> Enum.filter(fn {xx,yy} -> xx not in 0..map.width - 1 or yy not in 0..map.height - 1 end)
  #             |> Enum.map(fn p -> {p, i + 1} end)
  #             |> MapSet.new()
  #             |> MapSet.union(others)

  #             new_queue = MapSet.filter(new_queue, fn {xx,yy} -> xx in 0..map.width - 1 and yy in 0..map.height - 1 end)

  #             {:cont, {new_queue, {MapSet.size(new_queue), prev1, prev2}, new_others}}
  #         end
  #       end)

  #       new_queue = others
  #       |> Enum.group_by(fn {{x,y}, _} -> {floor(x/map.width), floor(y/map.height)} end)
  #       |> Enum.filter(fn {group, _} -> not MapSet.member?(acc.visited, group) end)
  #       |> Enum.map(fn {group, vals} ->
  #         vals
  #         |> Enum.group_by(fn {_, n} -> n end)
  #       end)
  #       |> IO.inspect()
  #       |> Enum.concat()

  #       {x,y} = st_pos

  #       {:cont, %{
  #         queue: rest_queue ++ new_queue,
  #         visited: MapSet.put(acc.visited, {floor(x/map.width), floor(y/map.height)}),
  #         total: acc.total + r
  #       }}
  #     end
  #   end)
  # end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename) |> get_starting_position()

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_21.main()
