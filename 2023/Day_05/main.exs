defmodule Day_05 do
  def parse_input(filename) do
    [seeds_str | rest] = File.read!(filename) |> String.split("\n\n", trim: true)
    seeds = seeds_str |> String.split() |> tl |> Enum.map(&String.to_integer/1)
    maps = rest
      |> Enum.map(fn cat -> String.split(cat, "\n", trim: true) |> tl |> Enum.map(&parse_map/1) end)
    %{seeds: seeds, maps: maps}
  end

  def parse_map(map_str) do
    String.split(map_str) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end

  def map_seed(seed, maps, reverse \\ false) do
    Enum.reduce(maps, seed, fn map, acc ->
      Enum.reduce_while(map, acc, fn {dest, source, range}, acc ->
        if reverse do
          if acc in dest..dest+range-1, do: {:halt, source + (acc - dest)}, else: {:cont, acc}
        else
          if acc in source..source+range-1, do: {:halt, dest + (acc - source)}, else: {:cont, acc}
        end
      end)
    end)
  end

  def part1(%{seeds: seeds, maps: maps}) do
    Enum.map(seeds, & map_seed(&1, maps))
    |> Enum.min()
  end

  # def part2(%{seeds: seeds, maps: maps}) do
  #   seeds
  #   |> Enum.chunk_every(2)
  #   |> Enum.reduce([], fn x, acc ->
  #     Enum.reduce_while(acc, x, fn [n, range], [n_acc, range_acc] ->
  #       if n_acc in n..n+range-1 do
  #         if n_acc + range_acc in n..n+range-1 do
  #           {:halt, nil}
  #         else
  #           {:cont, [range+1, range_acc]}
  #         end
  #       else
  #         if n_acc + range_acc in n..n+range-1 do
  #           {:cont, [n_acc, n-n_acc]}
  #         else
  #           {:cont, [n_acc, range_acc]}
  #         end
  #       end
  #     end)
  #     |> (& if &1 == nil, do: acc, else: [ &1 | acc ]).()
  #   end)
  #   |> Stream.map(fn [n, range] -> n..n+range-1 end)
  #   |> Stream.concat()
  #   |> Stream.map(fn seed -> map_seed(seed, maps) end)
  #   |> Enum.min()
  # end

  def part2(%{seeds: seeds, maps: maps}) do
    seeds = seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [n, range] -> n..n+range-1 end)

    reverse_maps = Enum.reverse(maps)

    Stream.iterate(0, & &1+1)
    |> Stream.chunk_every(32)
    |> Enum.reduce_while(nil, fn locations, _acc ->
      Enum.map(locations, fn location -> Task.async(fn -> map_seed(location, reverse_maps, reverse: true) end) end)
      |> Task.await_many()
      |> Enum.with_index()
      |> Enum.filter(fn {seed, _} -> Enum.any?(seeds, & seed in &1) end)
      |> then(fn
        [] -> {:cont, nil}
        [{_, i} | _] -> {:halt, Enum.at(locations, i)}
      end)
    end)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1", charlists: :as_lists)
    IO.inspect(part2(parsed_input), label: "Part 2", charlists: :as_lists)
  end
end

Day_05.main()
