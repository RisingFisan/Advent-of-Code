defmodule Day_06 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.trim
    |> String.to_charlist
  end

  def solve(input, number) do
    input
    |> Enum.chunk_every(number, 1)
    |> Enum.with_index(number)
    |> Enum.reduce_while(nil, fn {chars, i}, acc ->
      if length(Enum.uniq(chars)) == number do
        {:halt, i}
      else
        {:cont, acc}
      end
    end )
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(solve(parsed_input, 4), label: "Part 1")
    IO.inspect(solve(parsed_input, 14), label: "Part 2")
  end
end

Day_06.main
