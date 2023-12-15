# Mix.install([:nimble_parsec])

# defmodule Parser1 do
#   import NimbleParsec

#   def step_value(chars) do
#     Enum.reduce(chars, 0, fn char, acc ->
#       rem((acc + char) * 17, 256)
#     end)
#   end

#   step = repeat(
#     ascii_char([{:not, ?,}, {:not, ?\n}])
#   )
#   |> reduce(:step_value)

#   defparsec :sequence, step |> repeat(ignore(string(",")) |> concat(step))
# end

defmodule Day_15 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split(",")
  end

  def hash(sequence) do
    sequence
    |> String.to_charlist()
    |> Enum.reduce(0, fn char, acc ->
      rem((acc + char) * 17, 256)
    end)
  end

  def part1(input) do
    input
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.reduce(Map.new(), fn sequence, boxes ->
      [_, label | operation ] = Regex.run(~r/(\w+)(=|-)(\d+)?/, sequence)
      box = hash(label)
      label = String.to_atom(label)
      case operation do
        ["=", value] -> Map.update(boxes, box, [{label, String.to_integer(value)}], fn lenses ->
          Keyword.update(lenses, label, String.to_integer(value), fn _ -> String.to_integer(value) end)
        end)
        ["-"] -> Map.update(boxes, box, [], fn lenses -> Enum.reject(lenses, fn {lb, _} -> lb == label end) end)
      end
    end)
    |> Enum.map(fn {box, lenses} ->
      lenses
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn {{_label, value}, i}, acc ->
        acc + ((box + 1) * i * value)
      end)
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

Day_15.main()
