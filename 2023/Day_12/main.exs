Mix.install([:memoize])

defmodule Day_12 do
  use Memoize

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> then(fn [a,b] -> {String.to_charlist(a), String.split(b, ",") |> Enum.map(&String.to_integer/1)} end)
    end)
  end

  defmemo check_variations([], [], _), do: 1
  defmemo check_variations([], [0], _), do: 1
  defmemo check_variations([], _, _), do: 0
  defmemo check_variations([?# | _], [], _), do: 0
  defmemo check_variations([?? | t], [], _inseq), do: (if ?# not in t, do: 1, else: 0)
  defmemo check_variations([?. | t], [], _inseq), do: (if ?# not in t, do: 1, else: 0)
  defmemo check_variations([?# | t], [n | tn], true), do: (if n > 0, do: check_variations(t, [n - 1 | tn], true), else: 0)
  defmemo check_variations([?# | t], [n | tn], false), do: check_variations(t, [n - 1 | tn], true)
  defmemo check_variations([?. | t], [0 | tn], _), do: check_variations(t, tn, false)
  defmemo check_variations([?. | _], _, true), do: 0
  defmemo check_variations([?. | t], tn, _), do: check_variations(t, tn, false)
  defmemo check_variations([?? | t], [n | tn], inseq) do
    if n > 0 do
      if inseq do
        if length(Enum.take_while(t, & &1 != ?.)) >= n - 1, do: check_variations(Enum.drop(t, n - 1), [0 | tn], true), else: 0
      else
        check_variations(t, [n - 1 | tn], true) + check_variations(t, [n | tn], false)
      end
    else
      check_variations(t, tn, false)
    end
  end

  def part1(input) do
    input
    |> Enum.map(fn {springs, count} ->
        check_variations(springs, count, false)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn {springs, count} ->
      {List.duplicate(springs, 5)
      |> Enum.join("?")
      |> String.to_charlist(),
      List.duplicate(count, 5)
      |> Enum.concat()
      }
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

Day_12.main()
