defmodule Day03 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn element -> String.graphemes(element) |> Enum.map(&String.to_integer/1) end)
  end

  def part1(filename) do
    parse_input(filename)
    |> Enum.zip_with(fn elems -> Enum.frequencies(elems) |> then(&(&1[1] > &1[0]) |> if(do: 1, else: 0)) end)
    |> then(fn l -> Integer.undigits(l, 2) * (Enum.map(l, &(Bitwise.bxor(&1, 1))) |> Integer.undigits(2)) end)
  end

  def part2(filename) do
    parse_input(filename)
    |> then(fn l -> {get_o2(l, 0), get_co2(l, 0)} end)
    |> then(fn {a,b} -> Integer.undigits(a, 2) * Integer.undigits(b, 2) end)
  end

  defp get_o2(l = [x], _), do: x
  defp get_o2(list, index) do
    most_common = Enum.map(list, &(Enum.at(&1, index))) |> Enum.frequencies() |> then(&(&1[0] > &1[1])) |> if(do: 0, else: 1)

    Enum.filter(list, fn element ->
      Enum.at(element, index) == most_common
    end)
    |> get_o2(index + 1)
  end

  defp get_co2(l = [x], _), do: x
  defp get_co2(list, index) do
    least_common = Enum.map(list, &(Enum.at(&1, index))) |> Enum.frequencies() |> then(&(&1[0] > &1[1])) |> if(do: 1, else: 0)

    Enum.filter(list, fn element ->
      Enum.at(element, index) == least_common
    end)
    |> get_co2(index + 1)
  end
end

IO.inspect(Day03.part1("input"))
IO.inspect(Day03.part2("input"))
