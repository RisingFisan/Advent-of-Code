defmodule Day_21 do
  @ops %{
    +: &(&1 + &2),
    -: &(&1 - &2),
    *: &(&1 * &2),
    /: &(Kernel.div/2)
  }

  @inverse %{
    -: &(&1 + &2),
    +: &(&1 - &2),
    /: &(&1 * &2),
    *: &(Kernel.div/2)
  }

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ": ", parts: 2, trim: true)
      |> (fn [monkey, job] ->
        job = if job =~ ~r/[[:digit:]]+/ do
          String.to_integer(job)
        else
          Regex.run(~r/([[:alpha:]]+) ([+\-*\/]) ([[:alpha:]]+)/, job)
          |> tl
          |> Enum.map(&String.to_atom/1)
        end
        {String.to_atom(monkey), job}
      end).()
    end)
    |> Map.new
  end

  def yells(monkeys) do
    new_monkeys = Enum.reduce(monkeys, %{}, fn {monkey, job}, acc ->
      case job do
        [a, op, b] ->
          if is_integer(monkeys[a]) and is_integer(monkeys[b]) do
            Map.put(acc, monkey, apply(@ops[op], [monkeys[a], monkeys[b]]))
          else
            Map.put(acc, monkey, job)
          end
        _ ->
          Map.put(acc, monkey, job)
      end
    end)
    if new_monkeys == monkeys do
      new_monkeys
    else
      yells(new_monkeys)
    end
  end

  def simplify("X", _), do: "X"
  def simplify(x, _) when is_integer(x), do: x
  def simplify([a, op, b], dict) do
    if is_integer(dict[a]) and is_integer(dict[b]) do
      apply(@ops[op], [dict[a], dict[b]])
    else
      [simplify(dict[a], dict), op, simplify(dict[b], dict)]
    end
  end

  def solve("X", v), do: v
  def solve([a, op, b], v) do
    if is_integer(b) do
      solve(a, apply(@inverse[op], [v, b]))
    else
      if op in [:-,:/] do
        solve(b, apply(@ops[op], [a, v]))
      else
        solve(b, apply(@inverse[op], [v, a]))
      end
    end
  end

  def part1(input) do
    yells(input)
    |> Map.get(:root)
  end

  def part2(input) do
    new_input = input
    |> Map.delete(:humn)
    |> Map.update!(:root, fn [a, _op, b] ->
      [a, :=, b]
    end)
    |> yells()

    simplify(new_input[:root], new_input |> Map.put(:humn, "X"))
    |> (fn [a, :=, b] ->
      if is_integer(a) do
        solve(b, a)
      else
        solve(a, b)
      end
    end).()
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end
