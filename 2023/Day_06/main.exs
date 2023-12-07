defmodule Day_06 do
  @moduledoc """
  MATH TIME!

  If the button is held for X ms, knowing that the race has a record time of T ms, the distance traveled is:

  if X >= T: 0
  if X <  T: (T - X) * X

  Therefore, just need to find out how many times X < T AND (T - X) * X > Record distance.

  To further narrow down the possible values of X, we can solve the equation (T - X) * X > R for X

  (T - X) * X > R
  TX - X^2 > R
  X^2 - TX + R < 0

  Solving X^2 - TX + R = 0 gives us two possible values for X, the lower bound and the upper bound.

  Then we just need to calculate how many values are between these bounds.

  max(X1, X2) - min(X1, X2) - 1

  """

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
  end

  def quadratic_result(a, b, c) do
    x1 = (-b + :math.sqrt(b ** 2 - 4 * a * c)) / (2 * a)
    x2 = (-b - :math.sqrt(b ** 2 - 4 * a * c)) / (2 * a)
    ceil(max(x1,x2)) - floor(min(x1,x2)) - 1
  end

  def part1(input) do
    input
    |> Enum.map(fn line -> String.split(line) |> tl |> Enum.map(&String.to_integer/1) end)
    |> Enum.zip()
    |> Enum.reduce(1, fn {time, record_distance}, acc ->
      acc * quadratic_result(1, -time, record_distance)
    end)
  end

  def part2(input) do
    input
    |> Enum.map(fn line -> String.split(line) |> tl |> Enum.join() |> String.to_integer() end)
    |> then(fn [time, record_distance] -> quadratic_result(1, -time, record_distance) end)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_06.main()
