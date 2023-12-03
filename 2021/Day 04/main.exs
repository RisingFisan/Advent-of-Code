defmodule Position do
  @enforce_keys :value
  defstruct [:value, matched: false]
end

defmodule Day04 do
  def parse_input(filepath) do
    [ inputs | boards ] =
      File.read!(filepath)
      |> String.split("\n\n", trim: true)

    boards = for board <- boards do
      board = board |> String.split("\n", trim: true)
      for i <- 0..4 do
        row = board |> Enum.at(i) |> String.split(~r/\s+/, trim: true)
        for j <- 0..4 do
          %Position{value: row |> Enum.at(j)}
        end
      end
    end
    { String.split(inputs, ",", trim: true), boards}
  end

  def fill_board(board, value) do
    for i <- 0..4 do
      row = Enum.at(board, i)
      for j <- 0..4 do
        element = Enum.at(row, j)
        if element.value == value, do: %{ element | matched: true }, else: element
      end
    end
  end

  def has_match?(board) do
    Enum.any?(for i <- 0..4 do
      row = Enum.at(board, i)
      Enum.all?(row, fn element -> element.matched end)
    end)
    or
    Enum.any?(for j <- 0..4 do
      Enum.all?(board |> Enum.map(& Enum.at(&1, j)), fn element -> element.matched end)
    end)

  end

  def part1(filepath) do
    {inputs, boards} = parse_input(filepath)
    Enum.reduce_while(inputs, boards, fn input, acc ->
      acc = for board <- acc do
        fill_board(board, input)
      end
      matches = for board <- acc, has_match?(board), do: board
      if length(matches) > 0 do
        score = Enum.reduce(Enum.at(matches, 0), 0, fn row, acc ->
          acc + Enum.reduce(row, 0, fn element, acc ->
            if element.matched, do: acc, else: acc + String.to_integer(element.value)
          end)
        end)
        {:halt, score * String.to_integer(input)}
      else
        {:cont, acc}
      end
    end)
  end

  def part2(filepath) do
    {inputs, boards} = parse_input(filepath)
    Enum.reduce_while(inputs, boards, fn input, acc ->
      acc = for board <- acc do
        fill_board(board, input)
      end
      matches = for board <- acc, has_match?(board), do: board
      if length(acc) == length(matches) do
        score = Enum.reduce(Enum.at(matches, 0), 0, fn row, acc ->
          acc + Enum.reduce(row, 0, fn element, acc ->
            if element.matched, do: acc, else: acc + String.to_integer(element.value)
          end)
        end)
        {:halt, score * String.to_integer(input)}
      else
        {:cont, acc -- matches}
      end
    end)
  end
end


IO.inspect(Day04.part1("input"), label: "Part 1")
IO.inspect(Day04.part2("input"), label: "Part 2")
