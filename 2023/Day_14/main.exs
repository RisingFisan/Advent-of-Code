defmodule Day_14 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.to_charlist(line) end)
  end

  def get_rocks(map) do
    height = length(map)
    width = length(Enum.at(map, 0))
    for y <- 0..height-1,
        x <- 0..width-1,
        (rock = Enum.at(map, y) |> Enum.at(x)) != ?. do
      case rock do
        ?O -> {:rounded, {x,y}}
        ?# -> {:cubed, {x,y}}
      end
    end
    |> Enum.group_by(& elem(&1, 0), & elem(&1, 1))
    |> Map.put(:height, height)
    |> Map.put(:width, width)
  end

  def tilt_north(input = %{rounded: rounded, cubed: cubed}) do
    new_rounded = rounded
    |> Enum.sort(fn {x1,y1}, {x2,y2} -> {y1,x1} <= {y2,x2} end)
    |> Enum.reduce(MapSet.new(), fn rock = {x,y}, acc ->
      new_rock = {x, y-1}
      if new_rock not in cubed and y > 0 and new_rock not in acc do
        MapSet.put(acc, new_rock)
      else
        MapSet.put(acc, rock)
      end
    end)

    if new_rounded == rounded do
      new_rounded
    else
      tilt_north(%{input | rounded: new_rounded})
    end
  end

  def part1(input = %{height: height}) do
    tilt_north(input)
    |> Enum.reduce(0, fn {_x,y}, acc ->
      acc + (height - y)
    end)
  end

  def rotate(cubes, height) do
    MapSet.new(cubes, fn {x,y} ->
      {height - y - 1, x}
    end)
  end

  def part2(input = %{height: height}) do
    loads = Enum.reduce_while(Stream.iterate(0, & &1 + 1), {input, []}, fn _i, {input, loads} ->
      new_input = Enum.reduce(0..3, input, fn _, acc = %{cubed: cubed} ->
        new_rounded = tilt_north(acc) |> rotate(height)
        new_cubed = cubed |> rotate(height)
        %{rounded: new_rounded, cubed: new_cubed}
      end)
      load = Enum.reduce(new_input.rounded, 0, fn {_, y}, acc ->
        acc + (height - y)
      end)
      if [ load | Enum.take(loads, 3) ] in Enum.chunk_every(loads, 4, 1, :discard) do
        {:halt, [load | loads]}
      else
        {:cont, {new_input, [ load | loads ]}}
      end
    end)
    [h | t] = loads
    cycle_length = Enum.find_index(t, & &1 == h) + 1
    diff = rem(1_000_000_000, cycle_length) - rem(length(loads), cycle_length)
    loads |> Enum.drop(cycle_length + diff) |> hd()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)
    rocks = get_rocks(parsed_input)

    IO.inspect(part1(rocks), label: "Part 1")
    IO.inspect(part2(rocks), label: "Part 2")
  end
end

Day_14.main()
