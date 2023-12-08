defmodule Day_08 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n\n")
    |> then(fn [insts, network | _] ->
      %{
        instructions: String.to_charlist(insts),
        network: network
          |> String.split("\n", trim: true)
          |> Enum.map(fn line ->
            [_, e, l, r] = Regex.run(~r/(\w{3}) = \((\w{3}), (\w{3})\)/, line)
            {e, {l, r}}
          end)
          |> Map.new()
      }
    end)
  end

  def gcd(x, 0), do: x
  def gcd(0, x), do: x
  def gcd(a, b), do: gcd(b, rem(a, b))

  def part1(input) do
    Enum.reduce_while(Stream.repeatedly(fn -> input.instructions end) |> Stream.concat(), {1, "AAA"}, fn dir, {i, node} ->
      {l, r} = Map.get(input.network, node)
      next_node = case dir, do: (?L -> l; ?R -> r)
      if next_node == "ZZZ", do: {:halt, i}, else: {:cont, {i + 1, next_node}}
    end)
  end

  def part2(input) do
    starting_nodes = Map.keys(input.network) |> Enum.filter(& String.ends_with?(&1, "A"))
    Enum.reduce_while(Stream.repeatedly(fn -> input.instructions end) |> Stream.concat(), {1, starting_nodes, []}, fn dir, {i, nodes, acc} ->
      if length(nodes) == 0 do
        {:halt, acc}
      else
        next_nodes = Enum.map(nodes, fn node ->
          {l, r} = Map.get(input.network, node)
          case dir, do: (?L -> l; ?R -> r)
        end)
        {:cont,
          {
            i + 1,
            Enum.reject(next_nodes, & String.ends_with?(&1, "Z")),
            (if Enum.any?(next_nodes, & String.ends_with?(&1, "Z")), do: [ i | acc ], else: acc)
          }
        }
      end
    end)
    |> Enum.reduce(fn n, acc -> div(n * acc, gcd(n, acc)) end)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_08.main()
