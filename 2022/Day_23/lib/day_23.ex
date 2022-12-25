defmodule Day_23 do
  @dirs [:N, :S, :W, :E]

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, y}, acc ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce([], fn {point, x}, acc ->
        if point == "#" do
          [{x,y} | acc]
        else
          acc
        end
      end)
      |> Kernel.++(acc)
    end)
  end

  def look_around(elves, {x,y}, dirs) do
    if Enum.all?([{x-1,y-1},{x,y-1},{x+1,y-1},{x-1,y+1},{x,y+1},{x+1,y+1},{x+1,y},{x-1,y}], fn {xx,yy} -> {xx,yy} not in elves end) do
      nil
    else
      Enum.reduce_while(dirs, nil, fn d, acc ->
        case d do
          :N -> if Enum.all?([{x-1,y-1},{x,y-1},{x+1,y-1}], fn {xx,yy} -> {xx,yy} not in elves end) do
            {:halt, {x,y-1}}
          else
            {:cont, acc}
          end
          :S -> if Enum.all?([{x-1,y+1},{x,y+1},{x+1,y+1}], fn {xx,yy} -> {xx,yy} not in elves end) do
            {:halt, {x,y+1}}
          else
            {:cont, acc}
          end
          :E -> if Enum.all?([{x+1,y-1},{x+1,y},{x+1,y+1}], fn {xx,yy} -> {xx,yy} not in elves end) do
            {:halt, {x+1,y}}
          else
            {:cont, acc}
          end
          :W -> if Enum.all?([{x-1,y-1},{x-1,y},{x-1,y+1}], fn {xx,yy} -> {xx,yy} not in elves end) do
            {:halt, {x-1,y}}
          else
            {:cont, acc}
          end
        end
      end)
    end
  end

  def remove_duplicates([], _), do: []
  def remove_duplicates([ nil | t ], duplicates), do: [ nil | remove_duplicates(t, duplicates) ]
  def remove_duplicates([ h | t ], duplicates) do
    if h in duplicates or h in t do
      [ nil | remove_duplicates(t, MapSet.put(duplicates, h)) ]
    else
      [ h | remove_duplicates(t, duplicates) ]
    end
  end

  def part1(input) do
    elves = Enum.reduce_while(1..10, input, fn i, input ->
      dirs = for j <- i..i+3, do: Enum.at(@dirs, rem(j-1, 4))
      List.foldr(input, [], fn {x, y}, proposals ->
        [ look_around(input, {x,y}, dirs) | proposals ]
      end)
      |> remove_duplicates(MapSet.new())
      |> (fn proposals ->
        if Enum.all?(proposals, &is_nil/1) do
          {:halt, input}
        else
          {:cont, Enum.zip_with(proposals, input, fn new_pos, old_pos -> if is_nil(new_pos), do: old_pos, else: new_pos end)}
        end
      end).()
    end)
    bounds = Enum.reduce(elves, %{min_x: :infinity, max_x: 0, min_y: :infinity, max_y: 0}, fn {x, y}, acc ->
      %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y} = acc

      %{
        min_x: min(min_x, x),
        max_x: max(max_x, x),
        min_y: min(min_y, y),
        max_y: max(max_y, y)
      }
    end)

    for y <- bounds.min_y..bounds.max_y do
      s = for x <- bounds.min_x..bounds.max_x do
        if {x, y} in elves do
          IO.write("#")
          0
        else
          IO.write(".")
          1
        end
      end
      IO.puts("")
      Enum.sum(s)
    end
    |> Enum.sum
  end

  def part2(input) do
    Enum.reduce_while(Stream.iterate(1, & &1+1), input, fn i, input ->
      dirs = for j <- i..i+3, do: Enum.at(@dirs, rem(j-1, 4))
      Enum.map(input, fn {x, y} ->
        Task.async(fn -> look_around(input, {x,y}, dirs) end)
      end)
      |> Task.await_many()
      |> remove_duplicates(MapSet.new())
      |> (fn proposals ->
        if Enum.all?(proposals, &is_nil/1) do
          {:halt, i}
        else
          {:cont, Enum.zip_with(proposals, input, fn new_pos, old_pos -> if is_nil(new_pos), do: old_pos, else: new_pos end)}
        end
      end).()
    end)
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end

  def pretty_print(elves) do
    bounds = Enum.reduce(elves, %{min_x: :infinity, max_x: 0, min_y: :infinity, max_y: 0}, fn {x, y}, acc ->
      %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y} = acc

      %{
        min_x: min(min_x, x),
        max_x: max(max_x, x),
        min_y: min(min_y, y),
        max_y: max(max_y, y)
      }
    end)

    for y <- bounds.min_y - 2..bounds.max_y + 2 do
      for x <- bounds.min_x - 2..bounds.max_x + 2 do
        if {x, y} in elves do
          IO.write("#")
        else
          IO.write(".")
        end
      end
      IO.puts("")
    end
    elves
  end
end
