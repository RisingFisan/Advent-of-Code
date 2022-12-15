defmodule Day_15 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/-?\d+/, line)
      |> Enum.concat
      |> Enum.map(&String.to_integer/1)
      |> then(fn [xs,ys,xb,yb] ->
        %{sensor: {xs,ys}, beacon: {xb,yb}}
      end)
    end)
  end

  def part1(input, y) do
    input
    |> Enum.map(fn %{sensor: {xs,ys}, beacon: {xb,yb}} ->
      dist = abs(xs - xb) + abs(ys - yb)
      if ys < y and ys + dist >= y or ys > y and ys - dist <= y do
        s = dist - abs(ys - y)
        Enum.to_list(xs - s..xs + s)
      else
        []
      end
    end)
    |> Enum.concat
    |> MapSet.new
    |> MapSet.difference(MapSet.new(Enum.reduce(input, [], fn %{beacon: {xb,yb}}, acc ->
      if yb == y, do: [ xb | acc ], else: acc
    end)))
    |> MapSet.size
  end

  def part2(input, limit) do
    Enum.reduce_while(input, nil, fn %{sensor: {xs,ys}, beacon: {xb,yb}}, acc ->
      dist = abs(xs - xb) + abs(ys - yb)
      for i <- -dist - 1..dist + 1, m <- [-1,1], reduce: [] do
        acc ->
          {x,y} = {xs + i, ys + m * (dist + 1 - abs(i))}
          if x >= 0 and y >= 0 and x <= limit and y <= limit and
          Enum.reduce_while(input, true, fn %{sensor: {xs,ys}, beacon: {xb,yb}}, _ ->
            if abs(xs - xb) + abs(ys - yb) < abs(xs - x) + abs(ys - y), do: {:cont, true}, else: {:halt, false}
          end), do: [ {x,y} | acc ], else: acc
      end
      |> then(fn
        [] -> {:cont, acc}
        [h] -> {:halt, h}
      end)
    end)
    |> then(fn {x,y} -> x * 4_000_000 + y end)
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input, (if String.ends_with?(filename,"example.txt"), do: 10, else: 2_000_000)), label: "Part 1")
    IO.inspect(part2(parsed_input, (if String.ends_with?(filename,"example.txt"), do: 20, else: 4_000_000)), label: "Part 2")
  end
end
