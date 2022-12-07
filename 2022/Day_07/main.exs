defmodule Day_07 do
  @type filesystem :: %{dir :: binary() => filesystem, file :: binary() => filesize :: non_neg_integer() }

  @spec parse_input(binary) :: filesystem
  def parse_input(filename) do
    filesystem = %{"/" => %{}}

    File.read!(filename)
    |> String.split(~r/\n(?=\$)/)
    |> Enum.map(& String.split(&1, "\n", trim: true))
    |> Enum.reduce({filesystem, []}, fn [ instruction | output ], {fs, cur_dir} ->
      case instruction do
        "$ ls" -> {get_and_update_in(fs, cur_dir, &{&1, Enum.map(output, fn line ->
          case String.split(line, " ", parts: 2) do
            ["dir", dirname] -> {dirname, %{}}
            [filesize, filename] -> {filename, String.to_integer(filesize)}
          end
        end) |> Map.new()}) |> elem(1), cur_dir}
        "$ cd .." -> {fs, Enum.drop(cur_dir, -1)}
        "$ cd " <> dir -> {fs, cur_dir ++ [dir]}
      end
    end)
    |> elem(0)
  end

  @spec part1(filesystem) :: non_neg_integer
  def part1(input) do
    max_size = 100_000

    calc_size({"/", input["/"]})
    |> Enum.filter(& &1 < max_size)
    |> Enum.sum
  end

  @spec calc_size({binary, filesystem}) :: non_neg_integer() | [non_neg_integer()]
  defp calc_size({_, files}) when is_map(files) do
    r = Enum.map(files, &calc_size/1)
    s = Enum.map(r, fn v ->
      case v do
        [ dirsize | _ ] -> dirsize
        size -> size
      end
    end) |> Enum.sum

    [ s | Enum.filter(r, & is_list(&1) and length(&1) > 0) |> Enum.concat]
  end
  defp calc_size({_, size}) do
    size
  end

  @spec part2(filesystem) :: non_neg_integer
  def part2(input) do
    total_space = 70_000_000
    needed_space = 30_000_000

    sizes = calc_size({"/", Map.get(input, "/")})
    total_size = hd(sizes)
    unused_space = total_space - total_size
    to_delete = needed_space - unused_space

    sizes
    |> Enum.sort()
    |> Enum.find(& &1 > to_delete)
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_07.main
