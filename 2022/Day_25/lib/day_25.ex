defmodule Day_25 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
  end

  def to_snafu(0, acc), do: acc
  def to_snafu(n, acc) do
    case rem(n, 5) do
      0 -> to_snafu(div(n, 5), "0" <> acc)
      1 -> to_snafu(div(n, 5), "1" <> acc)
      2 -> to_snafu(div(n, 5), "2" <> acc)
      3 -> to_snafu(div(n, 5) + 1, "=" <> acc)
      4 -> to_snafu(div(n, 5) + 1, "-" <> acc)
    end
  end

  def solve(input) do
    Enum.reduce(input, 0, fn line, acc ->
      acc + (
      line
      |> String.split("", trim: true)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce(0, fn {char, i}, acc ->
        case char do
          "=" -> -2
          "-" -> -1
          x -> String.to_integer(x)
        end * (5 ** i) + acc
      end))
    end)
    |> to_snafu("")
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(solve(parsed_input), label: "Answer")
  end
end
