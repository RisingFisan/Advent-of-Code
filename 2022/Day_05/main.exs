defmodule Day_05 do

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n\n", parts: 2)
    |> then(fn [crates, instructions] ->
      {parse_crates(crates), parse_instructions(instructions)}
    end)
  end

  defp parse_crates(string) do
    string
    |> String.split("\n")
    |> Enum.drop(-1)
    |> List.foldr(Map.new, fn line, crates ->
      Enum.chunk_every(line |> String.to_charlist |> tl, 1, 4)
      |> Enum.concat
      |> Enum.with_index(1)
      |> Enum.reduce(crates, fn {crate, i}, acc ->
        if crate != ?\s do
          Map.update(acc, i, [crate], fn prev_crates -> [ crate | prev_crates ] end)
        else
          acc
        end
      end)
    end)
  end

  defp parse_instructions(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      Regex.run(~r/move (\d+) from (\d+) to (\d+)/, l)
      |> tl
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
  end

  def solve({crates, instructions}, part1) do
    Enum.reduce(instructions, crates, fn {move, from, to}, crates ->
      {taken, new_crates} = Map.get(crates, from) |> Enum.split(move)
      Map.put(crates, from, new_crates)
      |> Map.update!(to, fn old_crates -> (if part1, do: Enum.reverse(taken), else: taken) ++ old_crates end)
    end)
    |> Enum.sort
    |> Enum.map(& elem(&1, 1) |> hd)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(solve(parsed_input, true), label: "Part 1")
    IO.inspect(solve(parsed_input, false), label: "Part 2")
  end
end

IO.inspect(:timer.tc(Day_05, :main, []) |> elem(0), label: "Time (uSecs)")
