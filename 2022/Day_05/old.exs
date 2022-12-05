defmodule Day_05 do

  def init([]), do: []
  def init([_]), do: []
  def init([ h | t ]), do: [ h | init(t) ]

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
    |> init
    |> Enum.map(fn l -> Enum.chunk_every(l |> String.to_charlist, 3, 4) |> Enum.map(& Enum.at(&1, 1)) end)
    |> Enum.zip
    |> Enum.map(fn t -> Tuple.to_list(t) |> Enum.drop_while(& &1 == ?\s) end)
  end

  defp parse_instructions(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> Regex.run(~r/move (\d+) from (\d+) to (\d+)/, l) |> tl |> Enum.map(&String.to_integer/1) |> List.to_tuple end)
  end

  def solve({crates, instructions}, part1) do
    Enum.reduce(instructions, crates, fn {move, from, to}, crates ->
      {new_crates, taken} = List.foldr(crates |> Enum.with_index(), {[],nil}, fn {line, i}, {acc_crates, acc_taken} ->
        if i == from - 1 do
          {taken, remaining} = Enum.split(line, move)
          {[ remaining | acc_crates], taken}
        else
          {[ line | acc_crates], acc_taken}
        end
      end)
      List.foldr(new_crates |> Enum.with_index(), [], fn {line, i}, acc ->
        if i == to - 1 do
          [ (if part1, do: Enum.reverse(taken), else: taken) ++ line | acc ]
        else
          [ line | acc ]
        end
      end)
    end)
    |> Enum.map(& hd(&1))
    |> List.to_string
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(solve(parsed_input, true), label: "Part 1")
    IO.inspect(solve(parsed_input, false), label: "Part 2")
  end
end

IO.inspect(:timer.tc(Day_05, :main, []) |> elem(0), label: "Time (uSecs)")
