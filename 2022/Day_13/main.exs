defmodule Day_13 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn pair -> String.split(pair, "\n", parts: 2) |> Enum.map(& Code.eval_string(&1) |> elem(0)) |> List.to_tuple end)
  end

  def lower_than([],[]), do: :maybe
  def lower_than(_,[]), do: :no
  def lower_than([],_), do: :yes
  def lower_than([h1 | t1],[h2 | t2]) when is_integer(h1) and is_integer(h2), do: if h1 < h2, do: :yes, else: (if h1 == h2, do: lower_than(t1,t2), else: :no)
  def lower_than([h1 | t1],[h2 | t2]) when is_integer(h1), do: lower_than([ [h1] | t1],[h2 | t2])
  def lower_than([h1 | t1],[h2 | t2]) when is_integer(h2), do: lower_than([h1 | t1],[ [h2] | t2])
  def lower_than([h1 | t1],[h2 | t2]), do: if (x = lower_than(h1,h2)) == :maybe, do: lower_than(t1,t2), else: x

  def part1(input) do
    input
    |> Enum.with_index(1)
    |> Enum.filter(fn {{a,b}, _i} ->
      lower_than(a,b) == :yes
    end)
    |> Enum.map(& elem(&1,1))
    |> Enum.sum
  end

  def part2(input) do
    input
    |> Enum.reduce([], fn {a,b}, acc -> [ a, b | acc ] end)
    |> Enum.concat([ [[2]] , [[6]] ])
    |> Enum.sort(& lower_than(&1,&2) != :no)
    |> Enum.with_index(1)
    |> Enum.reduce(1, fn {e,i}, acc ->
      if e in [ [[2]] , [[6]] ], do: acc * i, else: acc
    end)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_13.main
