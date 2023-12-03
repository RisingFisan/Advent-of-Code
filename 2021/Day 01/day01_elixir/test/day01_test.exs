defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "part 1 example" do
    assert Day01.part1("../example") == 7
  end

  test "part 2 example" do
    assert Day01.part2("../example") == 5
  end
end
