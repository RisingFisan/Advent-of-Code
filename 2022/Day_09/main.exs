defmodule Day_09 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [dir, n] = String.split(line, " ", parts: 2)
      {String.to_atom(dir), String.to_integer(n)}
    end)
  end

  def move(_,0,s), do: s
  def move(dir,n,s = %{knots: [ h | t ]}) do
    {xh, yh} = h
    new_h = case dir do
      :U -> {xh, yh + 1}
      :D -> {xh, yh - 1}
      :L -> {xh - 1, yh}
      :R -> {xh + 1, yh}
    end
    new_knots = [ new_h | move_knots(new_h, t) ]
    move(dir, n - 1, %{s | knots: new_knots, visited: MapSet.put(s.visited, Enum.at(new_knots, -1))}
    |> pretty_print
    )
  end

  def move_knots(_,[]), do: []
  def move_knots({xh,yh}, [{xt,yt} | t]) do
    new_t =
      if abs(xt - xh) < 2 and abs(yt - yh) < 2 do
        {xt,yt}
      else
        vertical = cond do
          yt < yh -> 1
          yt == yh -> 0
          True -> -1
        end
        horizontal = cond do
          xt < xh -> 1
          xt == xh -> 0
          True -> -1
        end
        {xt + horizontal, yt + vertical}
      end
    [ new_t | move_knots(new_t, t)]
  end

  def part1(input) do
    input
    |> Enum.reduce(%{visited: MapSet.new(), knots: [{0,0},{0,0}]}, fn {dir, n}, acc ->
      move(dir, n, acc)
    end)
    |> then(& MapSet.size(&1.visited))
  end

  def part2(input) do
    input
    |> Enum.reduce(%{visited: MapSet.new(), knots: List.duplicate({0,0}, 10)}, fn {dir, n}, acc ->
      move(dir, n, acc)
    end)
    |> then(& MapSet.size(&1.visited))
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    :timer.sleep(2000)
    IO.inspect(part2(parsed_input), label: "Part 2")
  end

  def pretty_print(s = %{:visited => v, :knots => k = [ h | t ]}) do
    knots = Enum.with_index(t, 1)
    {min_x, max_x} = Enum.map(Enum.concat(v, k), & elem(&1,0)) |> Enum.min_max # |> max(elem(h,0))
    {min_y, max_y} = Enum.map(Enum.concat(v, k), & elem(&1,1)) |> Enum.min_max # |> max(elem(h,1))
    IO.puts(String.duplicate("\n", 20))
    for y <- max_y..min_y do
      for x <- min_x..max_x do
        cond do
          {x,y} == h -> "H"
          n = Enum.find(knots, & elem(&1, 0) == {x,y}) -> to_string(elem(n, 1))
          {x,y} in v -> "#"
          True -> "."
        end
      end
    end |> Enum.join("\n") |> IO.puts()
    :timer.sleep(100)
    s
  end
end

Day_09.main
