lines = File.read!("input") |> String.split("\n", trim: true)

diagram = for line <- lines, reduce: %{} do
  acc ->
    [x1,y1,x2,y2] = Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/, line) |> tl |> Enum.map(&String.to_integer/1)
    if x1 == x2 or y1 == y2 do
      for x <- x1..x2, reduce: acc do
        acc -> for y <- y1..y2, reduce: acc do
          acc -> Map.update(acc, {x,y}, 1, & &1 +1)
        end
      end
    else
      acc
    end
end

IO.inspect(diagram |> Map.filter(& elem(&1, 1) > 1) |> Map.keys |> length, label: "Part 1")

diagram = for line <- lines, reduce: %{} do
  acc ->
    [x1,y1,x2,y2] = Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/, line) |> tl |> Enum.map(&String.to_integer/1)
    if x1 == x2 or y1 == y2 do
      for x <- x1..x2, reduce: acc do
        acc -> for y <- y1..y2, reduce: acc do
          acc -> Map.update(acc, {x,y}, 1, & &1 +1)
        end
      end
    else
      for {x,y} <- Enum.zip(x1..x2, y1..y2), reduce: acc do
        acc -> Map.update(acc, {x,y}, 1, & &1 + 1)
      end
    end
end

IO.inspect(diagram |> Map.filter(& elem(&1, 1) > 1) |> Map.keys |> length, label: "Part 2")
