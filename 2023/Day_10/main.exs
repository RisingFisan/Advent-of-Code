defmodule Day_10 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.to_charlist(line)
      |> Enum.map(fn
        ?. -> nil
        ?S -> :start
        ?| -> fn {{x,y}, :south} -> {{x,y+1}, :south}; {{x,y}, :north} -> {{x,y-1}, :north}; _ -> nil end
        ?- -> fn {{x,y},  :east} -> {{x+1,y},  :east}; {{x,y},  :west} -> {{x-1,y},  :west}; _ -> nil end
        ?L -> fn {{x,y}, :south} -> {{x+1,y},  :east}; {{x,y},  :west} -> {{x,y-1}, :north}; _ -> nil end
        ?J -> fn {{x,y}, :south} -> {{x-1,y},  :west}; {{x,y},  :east} -> {{x,y-1}, :north}; _ -> nil end
        ?7 -> fn {{x,y}, :north} -> {{x-1,y},  :west}; {{x,y},  :east} -> {{x,y+1}, :south}; _ -> nil end
        ?F -> fn {{x,y}, :north} -> {{x+1,y},  :east}; {{x,y},  :west} -> {{x,y+1}, :south}; _ -> nil end
      end)
    end)
  end

  def get_starting_pos(pipes) do
    pipes
    |> Enum.with_index()
    |> Enum.reduce({nil, nil}, fn {line, y}, acc ->
      if x = Enum.find_index(line, & &1 == :start), do: {x,y}, else: acc
    end)
  end

  def solve(%{start: start, pipes: pipes}) do
    points = Enum.reduce_while([:north, :east, :south, :west], nil, fn dir, _ ->
      iters = Enum.reduce_while(Stream.iterate(0, & &1 + 1), %{point: {start, dir}, path: [start]}, fn _i, %{point: point = {{x,y}, _}, path: path} ->
        if line = Enum.at(pipes, y) do
          if f = Enum.at(line, x) do
            if new_point = f.(point) do
              new_coords = elem(new_point, 0)
              if new_coords == start, do: {:halt, [ start | path ]}, else: {:cont, %{point: new_point, path: [ new_coords | path ]}}
            else
              {:halt, nil}
            end
          else
            {:halt, nil}
          end
        else
          {:halt, nil}
        end
      end)
      if iters, do: {:halt, iters}, else: {:cont, nil}
    end)
    part1 = div(length(points), 2)
    part2 = points
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [{x1, y1}, {x2, y2}], acc ->
      width = x2 - x1
      avg_height = (y1 + y2) / 2
      acc + (width * avg_height)
    end)
    |> abs()
    |> Kernel.-(part1 - 1) # I have no fucking clue why this works 💀
                           # I just noticed that, for the examples,
                           # the answer for part 2 always had this
                           # property, so I checked if it was also
                           # true for the input and it was 😭
                           # probably some freaky math shit
    {part1, part2}
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    pipes = parse_input(filename)
    start = get_starting_pos(pipes)
    parsed_input = %{start: start, pipes: List.update_at(pipes, elem(start, 1),
      fn line -> List.replace_at(line, elem(start, 0), fn
          {{x,y}, :south} -> {{x,y+1}, :south}
          {{x,y}, :north} -> {{x,y-1}, :north}
          {{x,y},  :east} -> {{x+1,y},  :east}
          {{x,y},  :west} -> {{x-1,y},  :west}
        end)
      end)}

    {part1, part2} = solve(parsed_input)

    IO.inspect(part1, label: "Part 1")
    IO.inspect(part2, label: "Part 2")
  end
end

Day_10.main()
