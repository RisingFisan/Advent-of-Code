defmodule Day_16 do
  @memoized %{}

  def parse_input(filename) do
    input = File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_,valve,flow_rate,neighbors] = Regex.run(~r/Valve ([A-Z][A-Z]) has flow rate=(\d+); tunnels? leads? to valves? ((?:[A-Z][A-Z], )*[A-Z][A-Z])/, line)
      {valve, String.to_integer(flow_rate), String.split(neighbors, ", ", trim: true)}
    end)

    graph = Enum.reduce(input, %{}, fn {valve, _, neighbors}, acc ->
      Map.put(acc, valve, neighbors)
    end)

    for {valve, flow_rate, _} <- input, reduce: %{} do
      acc -> Map.put(acc, valve, bfs(graph, valve)) |> update_in([valve], & Map.put(&1, :flow_rate, flow_rate))
    end
  end

  def bfs(graph, start) do
    queue = [start]
    dists = %{}
    visited = MapSet.new([start])

    Enum.reduce_while(Stream.iterate(1, & &1 + 1), {queue, dists, visited}, fn _i, {queue, dists, visited} ->
      case queue do
        [] -> {:halt, dists}
        [ current | queue ] ->
          neighbors = Map.get(graph, current, []) |> Enum.reject(& MapSet.member?(visited, &1))
          new_queue = queue ++ neighbors
          new_dists = Enum.reduce(neighbors, dists, fn neighbor, acc ->
            Map.put(acc, neighbor, Map.get(acc, current, 0) + 1)
          end)
          new_visited = MapSet.union(visited, MapSet.new(neighbors))
          {:cont, {new_queue, new_dists, new_visited}}
      end
    end)
  end

  # def get_pressure(_, _, _, 0, _, pressure, _), do: pressure
  # def get_pressure(valves, current, unvisited, time, delta_t, pressure, pps) do
  #   if delta_t > 0 do
  #     get_pressure(valves, current, unvisited, time - 1, delta_t - 1, pressure + pps, pps)
  #   else
  #     if MapSet.size(unvisited) > 0 do
  #       for v <- unvisited do
  #         dist = (valves[current] |> Map.get(v))
  #         new_pps = pps + valves[current].flow_rate
  #         get_pressure(valves, v, MapSet.delete(unvisited, v), time - 1, dist, pressure + new_pps, new_pps)
  #       end
  #       |> Enum.max
  #     else
  #       new_pps = pps + valves[current].flow_rate
  #       pressure + time * new_pps
  #     end
  #   end
  # end

  def get_pressure_2(_, _, _, 0, _, pressure, _), do: pressure
  def get_pressure_2(valves, currents, unvisited, time, deltas, pressure, pps) do
    [as,bs] = for {cur, delta} <- Enum.zip(currents, deltas) do
      if delta != 0 or MapSet.size(unvisited) == 0 do
        [{cur, delta - 1, (if delta == 0, do: valves[cur].flow_rate, else: 0)}]
      else
        for v <- unvisited do
          {v, valves[cur] |> Map.get(v), valves[cur].flow_rate}
        end
      end
    end
    if length(as) == 1 and length(bs) == 1 and elem(hd(as),0) == elem(hd(bs),0) do
      [{cur_a, delta_a, pps_a}] = as
      [{cur_b, delta_b, pps_b}] = bs
      new_pps = pps + pps_a + pps_b
      deltas = if delta_a < delta_b, do: [delta_a, -1], else: [-1, delta_b]
      get_pressure_2(valves, [cur_a, cur_b], MapSet.delete(unvisited, cur_a), time - 1, deltas, pressure + new_pps, new_pps)
    else
      combs = for a = {cur_a, _, _} <- as, b = {cur_b, _, _} <- bs, cur_a != cur_b, do: {a,b}
      for {{{cur_a, delta_a, pps_a},{cur_b, delta_b, pps_b}},i} <- combs |> Enum.with_index(1) do
        if time == 26, do: IO.puts("Total progress: #{i}/#{length(combs)}")
        new_pps = pps + pps_a + pps_b
        get_pressure_2(valves, [cur_a, cur_b], MapSet.delete(MapSet.delete(unvisited, cur_a), cur_b), time - 1, [delta_a, delta_b], pressure + new_pps, new_pps)
      end
      |> Enum.max
    end
  end

  def part1(input) do
    valves = input
    |> Map.filter(fn {v, %{flow_rate: fr}} -> fr > 0 or v == "AA" end)
    |> Map.keys

    get_pressure_2(input, ["AA","AA"], MapSet.new(valves) |> MapSet.delete("AA"), 30, [0, -1], 0, 0)
  end

  def part2(input) do
    valves = input
    |> Map.filter(fn {v, %{flow_rate: fr}} -> fr > 0 or v == "AA" end)
    |> Map.keys

    get_pressure_2(input, ["AA","AA"], MapSet.new(valves) |> MapSet.delete("AA"), 26, [0, 0], 0, 0)
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end
