defmodule Day_16 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.to_charlist(line) end)
  end

  def go_up({x,y}), do: {x,y-1,:up}
  def go_down({x,y}), do: {x,y+1,:down}
  def go_left({x,y}), do: {x-1,y,:left}
  def go_right({x,y}), do: {x+1,y,:right}

  def advance(map, p = {x,y}, dir) do
    case Enum.at(map, y) do
      nil -> []
      line -> case Enum.at(line, x) do
        nil -> []
        ?| -> case dir do
          :up -> [go_up(p)]
          :down -> [go_down(p)]
          :left -> [go_up(p), go_down(p)]
          :right -> [go_up(p), go_down(p)]
        end
        ?- -> case dir do
          :up -> [go_left(p), go_right(p)]
          :down -> [go_left(p), go_right(p)]
          :left -> [go_left(p)]
          :right -> [go_right(p)]
        end
        ?/ -> case dir do
          :up -> [go_right(p)]
          :down -> [go_left(p)]
          :left -> [go_down(p)]
          :right -> [go_up(p)]
        end
        ?\\ -> case dir do
          :up -> [go_left(p)]
          :down -> [go_right(p)]
          :left -> [go_up(p)]
          :right -> [go_down(p)]
        end
        ?. -> case dir do
          :up -> [go_up(p)]
          :down -> [go_down(p)]
          :left -> [go_left(p)]
          :right -> [go_right(p)]
        end
      end
    end
  end

  def sim_beam(map, queue, visited) do
    if length(queue) == 0 do
      visited
    else
      [ p = {x,y,dir} | rest_queue ] = queue
      if p in visited or y < 0 or x < 0 or y >= length(map) or x >= length(Enum.at(map, 0)) do
        sim_beam(map, rest_queue, visited)
      else
        next_spots = advance(map, {x,y}, dir)
        sim_beam(map, Enum.concat(rest_queue, next_spots), MapSet.put(visited, p))
      end
    end
  end

  def part1(input) do
    sim_beam(input, [{0,0,:right}], MapSet.new())
    |> MapSet.new(fn {x,y,_} -> {x,y} end)
    |> MapSet.size()
  end

  def part2(input) do
    height = length(input) - 1
    width = length(Enum.at(input, 0)) - 1
    for y <- 0..height,
        x <- 0..width do
          cond do
            x == 0 -> sim_beam(input, [{x,y,:right}], MapSet.new())
            y == 0 -> sim_beam(input, [{x,y,:down}], MapSet.new())
            x == width -> sim_beam(input, [{x,y,:left}], MapSet.new())
            y == height -> sim_beam(input, [{x,y,:up}], MapSet.new())
            true -> MapSet.new()
          end
        end
    |> Enum.map(fn visited ->
      MapSet.new(visited, fn {x,y,_} -> {x,y} end)
      |> MapSet.size()
    end)
    |> Enum.max()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_16.main()
