defmodule Day_08 do
  @type forest() :: [trees()]
  @type trees() :: [tree()]
  @type tree() :: {
    height :: non_neg_integer(),
    visibility :: :N | :V,
    trees_in_sight :: non_neg_integer()
  }

  @spec parse_input(binary()) :: forest()
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.codepoints(l)
      |> Enum.map(& {String.to_integer(&1), :N, 1})
    end)
  end

  @spec calculate(forest()) :: forest()
  def calculate(input) do
    for _i <- 1..4, reduce: input do
      matrix ->
        for row <- matrix do
          head = hd(row) |> elem(0)
          [ {head, :V, 0} | (for {e, ev, ess} <- Enum.drop(row, 1), reduce: {[], head, [head]} do
            {new_row, tallest, prev} ->
              ss = Enum.reduce_while(prev, 0, fn x, acc -> if x < e, do: {:cont, acc + 1}, else: {:halt, acc + 1} end)
              new_tallest = max(e, tallest)
              { new_row ++ [{e, (if e > tallest, do: :V, else: ev), ess * ss}], new_tallest, [ e | prev ]}
          end) |> elem(0) ]
        end
        |> Enum.zip_with(& &1) |> Enum.map(&Enum.reverse/1) # rotates the matrix 90º clockwise
    end
  end

  @spec part1(forest()) :: integer()
  def part1(input) do
    Enum.reduce(input, 0, fn row, acc ->
      acc + Enum.count(row, & elem(&1,1) == :V)
    end)
  end

  @spec part2(forest()) :: integer()
  def part2(input) do
    Enum.reduce(input, 0, fn row, acc ->
      max(Enum.map(row, & elem(&1, 2)) |> Enum.max, acc)
    end)
  end

  
  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename) |> calculate

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_08.main
