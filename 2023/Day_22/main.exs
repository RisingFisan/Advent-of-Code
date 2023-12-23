defmodule Cube do
  defstruct [:x, :y, :z]

  def parse_cube(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x,y,z] ->
      %Cube{x: x, y: y, z: z}
    end)
  end

  def fall(cube) do
    %Cube{cube | z: cube.z - 1}
  end
end

defmodule Brick do

  defstruct [:p1, :p2, falling: true]

  def parse_brick(input) do
    input
    |> String.split("~")
    |> then(fn [p1, p2] ->
      %Brick{p1: Cube.parse_cube(p1), p2: Cube.parse_cube(p2)}
    end)
  end

  def compare(brick1, brick2) do
    avg_z1 = (brick1.p1.z + brick1.p2.z) / 2
    avg_z2 = (brick2.p1.z + brick2.p2.z) / 2
    cond do
      avg_z1 < avg_z2 -> :lt
      avg_z1 == avg_z2 -> :eq
      true -> :gt
    end
  end

  def get_points(brick) do
    for x <- brick.p1.x..brick.p2.x,
        y <- brick.p1.y..brick.p2.y,
        z <- brick.p1.z..brick.p2.z do
          %Cube{x: x, y: y, z: z}
        end
  end

  def fall(brick, n) do
    %Brick{brick | p1: %Cube{brick.p1 | z: brick.p1.z - n}, p2: %Cube{brick.p2 | z: brick.p2.z - n}}
  end

  def can_fall(brick, bricks) do
    if brick.falling == false or brick.p1.z == 1 or brick.p2.z == 1 do
      0
    else
      Enum.reduce_while(Stream.iterate(0, & &1 + 1), get_points(brick), fn i, points ->
        new_points = MapSet.new(points, fn point -> Cube.fall(point) end)
        zs = MapSet.new(new_points, & &1.z)

        if Enum.all?(new_points, fn point -> point.z >= 1 end) and
          bricks
          |> Enum.filter(fn %Brick{p1: p1, p2: p2} -> not MapSet.disjoint?(MapSet.new(p1.z..p2.z), zs) end)
          |> Enum.map(&get_points/1)
          |> Enum.concat()
          |> MapSet.new()
          |> MapSet.disjoint?(new_points) do
          # {:halt, 1}
          {:cont, new_points}
        else
          {:halt, i}
        end
      end)
    end
  end

  def supporting(support, brick) do
    new_brick =
      fall(brick, 1)
      |> get_points()
      |> MapSet.new()

    support
    |> get_points()
    |> MapSet.new()
    |> MapSet.disjoint?(new_brick)
    |> Kernel.not()
  end
end

defmodule Day_22 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&Brick.parse_brick/1)
  end

  def fall(bricks) do
    if Enum.all?(bricks, fn brick -> not brick.falling end) do
      IO.puts("Fallen!")
      bricks
    else
      bricks
      |> Enum.sort(Brick)
      |> Enum.reduce([], fn brick, acc ->
        if (i = Brick.can_fall(brick, acc)) > 0 do
          # List.insert_at(acc, -1, Brick.fall(brick))
          [ Brick.fall(brick, i) | acc ]
        else
          [  %Brick{brick | falling: false} | acc ]
          # List.insert_at(acc, -1, %Brick{brick | falling: false})
        end
      end)
      |> fall()
    end
  end

  def fall2(bricks) do
    bricks
    |> Enum.sort(Brick)
    |> Enum.reduce([], fn brick, acc ->
      if (i = Brick.can_fall(brick, acc)) > 0 do
        # List.insert_at(acc, -1, Brick.fall(brick))
        [ Brick.fall(brick, i) | acc ]
      else
        [  %Brick{brick | falling: false} | acc ]
        # List.insert_at(acc, -1, %Brick{brick | falling: false})
      end
    end)
    |> Enum.count(fn brick -> brick.falling end)
  end

  def get_supports(bricks) do
    bricks
    |> break_list()
    |> Enum.map(fn {brick, other_bricks} ->
      {brick, Enum.filter(other_bricks, & Brick.supporting(brick, &1))}
    end)
  end

  def break_list(list) do
    for i <- 0..length(list) - 1 do
      {Enum.at(list, i), Enum.take(list, i) ++ Enum.drop(list, i+1)}
    end
  end

  def get_n_broken(bricks) do
    bricks
    |> break_list()
    |> Enum.filter(fn {{_, supporting}, other_bricks} ->
      length(supporting) == 0 or
      other_bricks
      |> Enum.map(& elem(&1, 1))
      |> Enum.concat()
      |> MapSet.new() # bricks that are being supported by at least one other brick
      |> then(& MapSet.subset?(MapSet.new(supporting), &1))
    end)
    # |> Enum.map(& elem(&1, 0))
    # |> IO.inspect()
    |> length()
  end

  def part1(bricks) do
    bricks
    |> fall()
    |> get_supports()
    # |> IO.inspect(limit: :infinity)
    |> get_n_broken()
  end

  def part2(bricks) do
    bricks
    |> fall()
    |> break_list()
    |> Enum.map(fn {_,bricks} ->
        Enum.map(bricks, fn brick -> %Brick{brick | falling: true} end)
        |> fall2()
    end)
    |> Enum.sum()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    # IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_22.main()
