defmodule Day_24 do

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{blizzards: MapSet.new, min_x: :infinity, max_x: 0, min_y: :infinity, max_y: 0}, fn {line, y}, acc ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {point, x}, acc ->
        case point do
          dir when dir in ["<",">","v","^"] -> %{acc | blizzards: MapSet.put(acc.blizzards, {x, y, dir})}
          "#" -> %{
            acc
            |
            min_x: min(acc.min_x, x),
            max_x: max(acc.max_x, x),
            min_y: min(acc.min_y, y),
            max_y: max(acc.max_y, y)
          }
          _ -> acc
        end
      end)
    end)
    |> (&
      Map.put(&1, :start, {&1.min_x + 1, &1.min_y})
      |> Map.put(:end, {&1.max_x - 1, &1.max_y})
    ).()
  end

  def move_blizzard({x, y, dir}) do
    case dir do
      ">" -> {x + 1, y, dir}
      "<" -> {x - 1, y, dir}
      "^" -> {x, y - 1, dir}
      "v" -> {x, y + 1, dir}
    end
  end

  def move_blizzards(blizzards, %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y}) do
    Enum.map(blizzards, fn blizz ->
      {x,y,dir} = move_blizzard(blizz)
      cond do
        x == max_x -> {min_x + 1, y, dir}
        x == min_x -> {max_x - 1, y, dir}
        y == max_y -> {x, min_y + 1, dir}
        y == min_y -> {x, max_y - 1, dir}
        true -> {x, y, dir}
      end
    end)
  end

  def part1(input) do
    Enum.reduce_while(Stream.iterate(0, & &1+1), {input.blizzards, [input.start]}, fn i, {blizzards, queue} ->
      new_blizzards = move_blizzards(blizzards, input)
      new_queue = for {x,y} <- queue do
        [
          {x + 1, y},
          {x - 1, y},
          {x, y + 1},
          {x, y - 1}
        ]
        |> Enum.filter(fn {x,y} ->
          not (Enum.any?(new_blizzards, fn {x2, y2, _} -> {x,y} == {x2,y2} end))
          and ((x > input.min_x
          and x < input.max_x
          and y > input.min_y
          and y < input.max_y) or {x,y} == input.end)
        end)
      end
      |> Enum.concat
      |> Kernel.++(Enum.filter(queue, fn {x,y} -> not Enum.any?(new_blizzards, fn {x2, y2, _} -> {x,y} == {x2,y2} end) end))
      |> Enum.uniq()
      # IO.inspect({i, length(new_queue)})
      if input.end in new_queue do
        {:halt, {new_blizzards, i+1}}
      else
        {:cont, {new_blizzards, new_queue}}
      end
    end)
  end

  def part2(input, t) do
    {new_blizzards, new_t} = Enum.reduce_while(Stream.iterate(t, & &1+1), {input.blizzards, [input.end]}, fn i, {blizzards, queue} ->
      new_blizzards = move_blizzards(blizzards, input)
      new_queue = for {x,y} <- queue do
        [
          {x + 1, y},
          {x - 1, y},
          {x, y + 1},
          {x, y - 1}
        ]
        |> Enum.filter(fn {x,y} ->
          not (Enum.any?(new_blizzards, fn {x2, y2, _} -> {x,y} == {x2,y2} end))
          and ((x > input.min_x
          and x < input.max_x
          and y > input.min_y
          and y < input.max_y) or {x,y} == input.start)
        end)
      end
      |> Enum.concat
      |> Kernel.++(Enum.filter(queue, fn {x,y} -> not Enum.any?(new_blizzards, fn {x2, y2, _} -> {x,y} == {x2,y2} end) end))
      |> Enum.uniq()
      if input.start in new_queue do
        {:halt, {new_blizzards, i+1}}
      else
        {:cont, {new_blizzards, new_queue}}
      end
    end)

    Enum.reduce_while(Stream.iterate(new_t, & &1+1), {new_blizzards, [input.start]}, fn i, {blizzards, queue} ->
      new_blizzards = move_blizzards(blizzards, input)
      new_queue = for {x,y} <- queue do
        [
          {x + 1, y},
          {x - 1, y},
          {x, y + 1},
          {x, y - 1}
        ]
        |> Enum.filter(fn {x,y} ->
          not (Enum.any?(new_blizzards, fn {x2, y2, _} -> {x,y} == {x2,y2} end))
          and ((x > input.min_x
          and x < input.max_x
          and y > input.min_y
          and y < input.max_y) or {x,y} == input.end)
        end)
      end
      |> Enum.concat
      |> Kernel.++(Enum.filter(queue, fn {x,y} -> not Enum.any?(new_blizzards, fn {x2, y2, _} -> {x,y} == {x2,y2} end) end))
      |> Enum.uniq()
      # IO.inspect({i, length(new_queue)})
      if input.end in new_queue do
        {:halt, i+1}
      else
        {:cont, {new_blizzards, new_queue}}
      end
    end)
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    {blizzards, a1} = part1(parsed_input)
    IO.inspect(a1, label: "Part 1")
    IO.inspect(part2(%{parsed_input | blizzards: blizzards}, a1), label: "Part 2")
  end
end
