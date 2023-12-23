defmodule Day_18 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, dir, n, color] = Regex.run(~r/([UDLR]) (\d+) \((#\w{6})\)/, line)
      %{
        dir: dir |> String.to_atom,
        n: n |> String.to_integer,
        color: color
      }
    end)
  end

  def move({x,y}, :U, n), do: {x, y - n}
  def move({x,y}, :D, n), do: {x, y + n}
  def move({x,y}, :L, n), do: {x - n, y}
  def move({x,y}, :R, n), do: {x + n, y}

  def part1(input) do
    points = Enum.reduce(input, [{0,0}], fn %{dir: d, n: n}, acc = [{x,y} | _] ->
      [ move({x,y}, d, n) | acc]
    end)
    |> Enum.chunk_every(2, 1, :discard)

    perimeter = points
    |> Enum.reduce(0, fn [{x1,y1},{x2,y2}], acc ->
      acc + abs(y2 - y1) + abs(x2 - x1)
    end)

    points
    |> Enum.reduce(0, fn [{x1,y1},{x2,y2}], acc ->
      acc + (x1 * y2 - x2 * y1)
    end)
    |> Kernel.abs()
    |> Kernel.div(2)
    |> then(fn area -> area + div(perimeter,2) + 1 end)
  end

  def part2(input) do
    input
    |> Enum.map(fn %{color: <<?#, dist::binary-size(5), dir>>} ->
      %{n: String.to_integer(dist, 16), dir: (case dir, do: (?3 -> :U; ?1 -> :D; ?2 -> :L; ?0 -> :R))}
    end)
    |> part1()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_18.main()
