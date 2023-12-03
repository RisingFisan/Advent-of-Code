defmodule Day_10 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
  end

  def run(input) do
    Enum.reduce(1..240, %{exec_t: 0, x: 1, total: 0, insts: input, crt: []}, fn cycle, acc ->
      total = if cycle in [20,60,100,140,180,220], do: acc.total + (acc.x * cycle), else: acc.total
      new_crt = List.insert_at(acc.crt, -1, (if abs(acc.x + 1 - rem(cycle,40)) <= 1, do: ?█, else: ?\s))
      new_acc = %{acc | total: total, crt: new_crt}
      case hd(acc.insts) do
        ["noop"] ->
          %{new_acc | insts: tl(acc.insts)}
        ["addx", n] -> if acc.exec_t == 0 do
          %{new_acc | exec_t: 1}
        else
          %{new_acc | exec_t: 0, x: acc.x + String.to_integer(n), insts: tl(acc.insts)}
        end
      end
    end)
  end

  def part1(input) do
    input.total
  end

  def part2(input) do
    input.crt
    |> Enum.chunk_every(40)
    |> Enum.join("\n")
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)
    result = run(parsed_input)

    IO.inspect(part1(result), label: "Part 1")
    IO.puts("Part 2:\n" <> part2(result))
  end
end

Day_10.main
