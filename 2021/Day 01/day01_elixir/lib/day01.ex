defmodule Day01 do
  @moduledoc """
  Documentation for `Day01`.
  """

  def part1(filepath) do
    File.read!(filepath)
    |> String.split()
    |> Stream.map(&String.to_integer(&1))
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.filter(fn [a, b] -> b > a end)
    |> Enum.to_list()
    |> length()
  end

  def part2(filepath) do
    File.read!(filepath)
    |> String.split()
    |> Stream.map(&String.to_integer(&1))
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.map(fn [a, b, c] -> a + b + c end)
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.filter(fn [a, b] -> b > a end)
    |> Enum.to_list()
    |> length()
  end
end

defmodule Mix.Tasks.Main do
  use Mix.Task

  def run(args) do
    filepath = Enum.at(args, 0, "../input")
    IO.inspect(filepath, label: "File")
    IO.inspect(Day01.part1(filepath), label: "Part 1")
    IO.inspect(Day01.part2(filepath), label: "Part 2")
    :ok
  end

end
