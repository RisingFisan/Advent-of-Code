defmodule Monkey do
  defstruct [:items, :operation_type, :operation_value, :test_number, :throw_if_true, :throw_if_false, inspections: 0]
end

defmodule Day_11 do
  def parse_input(filename) do
    regex_monkey = Regex.compile!(~S/Monkey \d+:
  Starting items: ((?:\d+, )*\d+)
  Operation: new = old ([+*]) (\d+|old)
  Test: divisible by (\d+)
    If true: throw to monkey (\d+)
    If false: throw to monkey (\d+)/, [:multiline])

    File.read!(filename)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn lines ->
      [_,items,op_type,op_val,div_n,throw_if_t,throw_if_f] = Regex.run(regex_monkey,lines)
      %Monkey{
        items: String.split(items,", ") |> Enum.map(&String.to_integer/1),
        operation_type: op_type |> String.to_atom(),
        operation_value: (if op_val =~ ~r/\d/, do: String.to_integer(op_val), else: :old),
        test_number: String.to_integer(div_n),
        throw_if_true: String.to_integer(throw_if_t),
        throw_if_false: String.to_integer(throw_if_f)
      }
    end)
  end

  def part1(input) do
    Enum.reduce(1..20, input, fn _round, monkeys ->
      Enum.reduce(0..length(monkeys) - 1, monkeys, fn i, new_monkeys ->
        monkey = Enum.at(new_monkeys, i)
        new_items = Enum.map(monkey.items, fn item -> div(case monkey.operation_type do
          :+ -> item + (if monkey.operation_value == :old, do: item, else: monkey.operation_value)
          :* -> item * (if monkey.operation_value == :old, do: item, else: monkey.operation_value)
          end, 3)
        end)
        Enum.reduce(new_items, new_monkeys, fn item, new_new_monkeys ->
          if rem(item, monkey.test_number) == 0 do
            List.update_at(new_new_monkeys, monkey.throw_if_true, fn mk -> %{mk | items: mk.items ++ [item]} end)
          else
            List.update_at(new_new_monkeys, monkey.throw_if_false, fn mk -> %{mk | items: mk.items ++ [item]} end)
          end
        end)
        |> List.replace_at(i, %{monkey | items: [], inspections: monkey.inspections + length(new_items)})
      end)
    end)
    |> Enum.map(& &1.inspections)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def part2(input) do
    lcm = Enum.product(Enum.map(input, & &1.test_number))
    Enum.reduce(1..10000, input, fn _round, monkeys ->
      Enum.reduce(0..length(monkeys) - 1, monkeys, fn i, new_monkeys ->
        monkey = Enum.at(new_monkeys, i)
        new_items = Enum.map(monkey.items, fn item ->
          rem(case monkey.operation_type do
            :+ -> item + (if monkey.operation_value == :old, do: item, else: monkey.operation_value)
            :* -> item * (if monkey.operation_value == :old, do: item, else: monkey.operation_value)
          end,lcm)
        end)
        Enum.reduce(new_items, new_monkeys, fn item, new_new_monkeys ->
          if rem(item, monkey.test_number) == 0 do
            List.update_at(new_new_monkeys, monkey.throw_if_true, fn mk -> %{mk | items: mk.items ++ [item]} end)
          else
            List.update_at(new_new_monkeys, monkey.throw_if_false, fn mk -> %{mk | items: mk.items ++ [item]} end)
          end
        end)
        |> List.replace_at(i, %{monkey | items: [], inspections: monkey.inspections + length(new_items)})
      end)
    end)
    |> Enum.map(& &1.inspections)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2", charlists: :as_lists)
  end
end

Day_11.main
