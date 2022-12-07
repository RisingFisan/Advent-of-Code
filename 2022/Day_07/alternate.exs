defmodule FileSystem do
  defstruct [:name, :size, :files]

  @type t :: %FileSystem{name: binary, size: non_neg_integer, files: [t]}

  def ls(fs = %{name: name}, path, files) do
    case path do
      [ ^name ] -> %{fs | files: Enum.map(files, &create_file/1)}
      [ ^name | path ] -> %{fs | files: Enum.map(fs.files, & ls(&1, path, files))}
      _ -> fs
    end
  end

  def create_file("dir " <> dirname) do
    %FileSystem{name: dirname}
  end
  def create_file(file) do
    [size, name] = String.split(file, " ", parts: 2)
    %FileSystem{name: name, size: String.to_integer(size)}
  end

  def calc_sizes(fs = %{size: nil}) do
    f = Enum.map(fs.files, &calc_sizes/1)
    %{fs | files: f, size: Enum.map(f, & &1.size) |> Enum.sum}
  end
  def calc_sizes(fs), do: fs

  def get_dir_sizes(_fs = %{files: nil}), do: []
  def get_dir_sizes(fs), do: [ fs.size | Enum.map(fs.files, &get_dir_sizes/1) |> Enum.concat() ]
end

defmodule Day_07 do
  @spec parse_input(binary) :: FileSystem.t()
  def parse_input(filename) do
    filesystem = %FileSystem{name: "/"}

    File.read!(filename)
    |> String.split(~r/\n(?=\$)/)
    |> Enum.map(& String.split(&1, "\n", trim: true))
    |> Enum.reduce({filesystem, []}, fn [ instruction | output ], {fs, cur_dir} ->
      case instruction do
        "$ ls" -> {FileSystem.ls(fs, cur_dir, output), cur_dir}
        "$ cd .." -> {fs, Enum.drop(cur_dir, -1)}
        "$ cd /" -> {fs, ["/"]}
        "$ cd " <> dir -> {fs, cur_dir ++ [dir]}
      end
    end)
    |> elem(0)
    |> FileSystem.calc_sizes()
  end

  @spec part1(FileSystem.t()) :: non_neg_integer()
  def part1(input) do
    max_size = 100_000

    input
    |> FileSystem.get_dir_sizes()
    |> Enum.filter(& &1 < max_size)
    |> Enum.sum
  end

  @spec part2(FileSystem.t()) :: non_neg_integer()
  def part2(input) do
    total_space = 70_000_000
    needed_space = 30_000_000

    sizes = FileSystem.get_dir_sizes(input)
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
