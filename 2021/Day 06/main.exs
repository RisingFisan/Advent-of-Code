defmodule Day06 do
  @initial_fish List.duplicate(0, 10)

  def parse_input(filename) do
    File.read!(filename)
    |> String.trim
    |> String.split(",", trim: true)
    |> Enum.reduce(@initial_fish, fn n, acc ->
      List.update_at(acc, String.to_integer(n), & &1 + 1)
    end)
  end

  def part1(filename) do
    fish = parse_input(filename)
    for _i <- 1..80, reduce: fish do
      acc ->
        zeros = Enum.at(acc, 0)
        for {n_fish, day} <- Enum.with_index(acc), day > 0, n_fish > 0, reduce: @initial_fish do
          acc -> List.insert_at(acc, day - 1, n_fish)
        end
        |> List.update_at(6, & &1 + zeros)
        |> List.update_at(8, & &1 + zeros)
    end
    |> Enum.sum()
  end

  def part2(filename) do
    fish = parse_input(filename)
    for _i <- 1..256, reduce: fish do
      acc ->
        zeros = Enum.at(acc, 0)
        for {n_fish, day} <- Enum.with_index(acc), day > 0, n_fish > 0, reduce: @initial_fish do
          acc -> List.insert_at(acc, day - 1, n_fish)
        end
        |> List.update_at(6, & &1 + zeros)
        |> List.update_at(8, & &1 + zeros)
    end
    |> Enum.sum()
  end
end

filename = Enum.at(System.argv, 0, "input")

IO.inspect(Day06.part1(filename), label: "Part 1")
IO.inspect(Day06.part2(filename), label: "Part 2")
