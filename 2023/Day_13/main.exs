defmodule Day_13 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn pattern ->
      String.split(pattern, "\n", trim: true)
      |> Enum.map(&String.to_charlist/1)
    end)
  end

  def transpose([[]|_]), do: []
  def transpose(m), do: [ Enum.map(m, &Kernel.hd/1) | transpose(Enum.map(m, &Kernel.tl/1)) ]

  def check_symmetry(pattern) do
    Enum.reduce_while(1..length(pattern)-1, nil, fn i, acc ->
      side1 = Enum.take(pattern, i) |> Enum.reverse()
      side2 = Enum.drop(pattern, i)
      mirror = Enum.zip(side1, side2)
      if Enum.all?(mirror, fn {a,b} -> a == b end) do
        {:halt, i}
      else
        {:cont, acc}
      end
    end)
  end

  def check_symmetry_2(pattern) do
    Enum.reduce_while(1..length(pattern)-1, nil, fn i, acc ->
      side1 = Enum.take(pattern, i) |> Enum.reverse()
      side2 = Enum.drop(pattern, i)
      mirror = Enum.zip(side1, side2)
      if all_but_one(mirror) == nil do
        {:cont, acc}
      else
        {:halt, i}
      end
    end)
  end

  def all_but_one(mirror) do
    Enum.with_index(mirror)
    |> Enum.reduce_while(nil, fn {{a,b}, y}, acc ->
      if a == b do
        {:cont, acc}
      else
        Enum.zip(a, b)
        |> Enum.with_index(1)
        |> Enum.reduce(nil, fn {{aa,bb}, x}, acc ->
          if aa == bb do
            acc
          else
            if acc == nil, do: x, else: :false
          end
        end)
        |> case do
          nil -> {:cont, nil}
          :false -> {:halt, nil}
          x -> if acc == nil, do: {:cont, {x,y}}, else: {:halt, nil}
        end
      end
    end)
  end

  def part1(input) do
    input
    |> Enum.map(fn pattern ->
      if i = check_symmetry(pattern) do
        i * 100
      else
        transpose(pattern)
        |> check_symmetry()
      end
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn pattern ->
      if i = check_symmetry_2(pattern) do
        i * 100
      else
        transpose(pattern)
        |> check_symmetry_2()
      end
    end)
    |> Enum.sum()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_13.main()
