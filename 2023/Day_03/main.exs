Mix.install([:nimble_parsec])

defmodule MyParser do
  import NimbleParsec

  def add_num_info(rest, [num], context, {line, col}, offset) do
    colnum = offset - col
    {rest, [%{number: num, x: {colnum - String.length(to_string(num)) + 1, colnum}, y: line}], context}
  end

  def add_sym_info(rest, [sym], context, {line, col}, offset) do
    colnum = offset - col
    {rest, [%{symbol: sym, x: colnum, y: line}], context}
  end

  number = integer(min: 1)
    |> post_traverse(:add_num_info)

  symbol = ascii_char([{:not, ?0..?9}, {:not, ?.}, {:not, ?\n}])
    |> post_traverse(:add_sym_info)

  line = times(choice([
    number,
    symbol,
    ignore(string("."))
  ]), min: 1)

  defparsec :lines, repeat(
    line
    |> ignore(optional(string("\n")))
  )
end

defmodule Day_03 do
  def parse_input(filename) do
    File.read!(filename)
    |> MyParser.lines()
    |> elem(1)
    |> Enum.reduce(%{numbers: [], symbols: []}, fn
      x = %{number: _}, acc -> %{ acc | numbers: [x | acc.numbers]}
      x = %{symbol: _}, acc -> %{ acc | symbols: [x | acc.symbols]}
    end)
    # |> String.split("\n", trim: true)
    # |> Enum.map(& String.to_charlist(&1) |> Enum.with_index())
    # |> Enum.with_index()
    # |> Enum.reduce(%{numbers: [], symbols: []}, fn {line, i}, acc ->
    #   numbers = parse_line(line) |> Enum.map(fn number -> Map.update!(number, :number, & String.to_integer(&1)) Map.put(:y, i) end)
    #   symbols = Enum.filter(line, fn {symb, _} -> symb not in ?0..?9 and symb != ?. end) |> Enum.map(fn {symb, j} -> %{symbol: symb, x: j, y: i} end)
    #   %{ numbers: Enum.concat(acc.numbers, numbers), symbols: Enum.concat(acc.symbols, symbols)}
    # end)
  end

  # def parse_line([]), do: []
  # def parse_line([ {h,i} | t ]) do
  #   r = parse_line(t)
  #   case r do
  #     [] -> if h in ?0..?9, do: [%{number: <<h>>, x: {i, i}}], else: []
  #     [ hr = %{number: n, x: {xi, xf}} | tr ] ->
  #       if h in ?0..?9 do
  #         (if i == xi - 1, do: [ %{number: <<h>> <> n, x: {i, xf}} | tr ], else: [ %{number: <<h>>, x: {i, i}}, hr | tr ])
  #       else
  #         [ hr | tr ]
  #       end
  #   end
  # end

  def part1(input) do
    Enum.reduce(input.symbols, 0, fn %{x: x, y: y}, acc ->
      Stream.filter(input.numbers, fn %{x: {xi, xf}, y: yn} -> x in (xi-1)..(xf+1) and y in (yn-1)..(yn+1) end)
      |> Stream.map(& &1.number)
      |> Enum.sum()
      |> Kernel.+(acc)
    end)
  end

  def part2(input) do
    input.symbols
    |> Enum.filter(& &1.symbol == ?*)
    |> Enum.reduce(0, fn %{x: x, y: y}, acc ->
      Enum.filter(input.numbers, fn %{x: {xi, xf}, y: yn} -> x in (xi-1)..(xf+1) and y in (yn-1)..(yn+1) end)
      |> (fn numbers ->
        if length(numbers) == 2 do
          Enum.map(numbers, & &1.number) |> Enum.product()
        else
          0
        end
      end).()
      |> Kernel.+(acc)
    end)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_03.main()
