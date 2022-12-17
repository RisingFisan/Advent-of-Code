defmodule Day_17 do
  @rocks [
    [{0,0},{1,0},{2,0},{3,0}],
    [{1,0},{0,1},{1,1},{1,2},{2,1}],
    [{0,0},{1,0},{2,0},{2,1},{2,2}],
    [{0,0},{0,1},{0,2},{0,3}],
    [{0,0},{0,1},{1,0},{1,1}]
  ]
  @max_x 6

  def parse_input(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.to_charlist()
  end

  def make_rock_fall(rock, tower, winds, cur_wind) do
    op = case Enum.at(winds, cur_wind) do
      ?< -> fn {x,y} -> {x-1,y} end
      ?> -> fn {x,y} -> {x+1,y} end
    end
    next_wind = rem(cur_wind+1, length(winds))

    new_rock = Enum.map(rock, op)
    rock = if Enum.any?(new_rock, fn {x,y} -> MapSet.member?(tower, {x,y}) or x > @max_x or x < 0 end), do: rock, else: new_rock
    new_rock = Enum.map(rock, fn {x,y} -> {x,y-1} end)
    if Enum.any?(new_rock, fn {x,y} -> MapSet.member?(tower, {x,y}) or y <= 0 end) do
      {rock, next_wind}
    else
      make_rock_fall(new_rock, tower, winds, next_wind)
    end
  end

  def run(input, n, get_cycles \\ false) do
    Enum.reduce_while(0..(n-1), {MapSet.new, 0, 0, []}, fn i, {tower, cur_wind, max_y, heights} ->
      rock = Enum.at(@rocks, rem(i,5))
      spawned_rock = Enum.map(rock, fn {x,y} -> {x+2, y+max_y+4} end)

      {final_rock, next_wind} = make_rock_fall(spawned_rock, tower, input, cur_wind)
      new_max_y = max(max_y, Enum.map(final_rock, & elem(&1,1)) |> Enum.max)
      new_tower = MapSet.union(tower, MapSet.new(final_rock))

      if get_cycles do
        new_heights = for x <- 0..@max_x do
          Enum.filter(new_tower, fn {x2,_y2} -> x2 == x end)
          |> Enum.map(& elem(&1,1))
          |> (&(if length(&1) > 0, do: new_max_y - Enum.max(&1), else: new_max_y)).()
        end ++ [rem(i,5), next_wind]

        p = for {h,j} <- heights, reduce: nil do
          acc -> if h == new_heights, do: {i, j}, else: acc
        end

        if is_nil(p) do
          {:cont, {new_tower, next_wind, new_max_y, [ {new_heights, i} | heights ]}}
        else
          {:halt, p}
        end
      else
        {:cont, {new_tower, next_wind, new_max_y, heights}}
      end
    end)
    |> (fn
      {_,_,c,_} -> c
      x -> x
    end).()
  end

  def solve(input) do
    run(input, 1_000_000_000_000, true)
    |> (fn {next, start} ->
      ratio = next - start
      cycle_start_part1 = rem(2022, ratio)
      cycle_start_part2 = rem(1_000_000_000_000, ratio)
      cycles_part1 = div(2022 - cycle_start_part1, ratio)
      cycles_part2 = div(1_000_000_000_000 - cycle_start_part2, ratio)
      delta_part1 = run(input, cycle_start_part1 + ratio) - (start_value_part1 = run(input, cycle_start_part1))
      delta_part2 = run(input, cycle_start_part2 + ratio) - (start_value_part2 = run(input, cycle_start_part2))
      {start_value_part1 + cycles_part1 * delta_part1,
       start_value_part2 + cycles_part2 * delta_part2}
    end).()
  end

  def main do
    Enum.at(System.argv, 1, "input.txt")
    |> parse_input()
    |> solve()
    |> (fn {part1, part2} ->
      IO.inspect(part1, label: "Part 1")
      IO.inspect(part2, label: "Part 1")
    end).()
  end

  def pretty_print(tower, max_y) do
    for y <- max_y+3..1//-1 do
      IO.write("|")
      for x <- 0..@max_x do
        if MapSet.member?(tower, {x,y}) do
          IO.write("#")
        else
          IO.write(".")
        end
      end
      IO.puts("|")
    end
    IO.puts("+" <> String.duplicate("-", @max_x + 1) <> "+")
  end
end
