defmodule Day_22 do

  # WARNING: THIS SOLUTION ONLY WORKS FOR MY INPUT BECAUSE FUCK CUBES

  @turn_left %{
    U: :L,
    L: :D,
    D: :R,
    R: :U
  }

  @turn_right %{
    U: :R,
    R: :D,
    D: :L,
    L: :U
  }

  @dir_score %{
    R: 0,
    D: 1,
    L: 2,
    U: 3
  }

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n\n", trim: true)
    |> (fn [board, moves] ->
      {
        board
        |> String.split("\n", trim: true)
        |> Enum.with_index(1)
        |> Enum.reduce(%{}, fn {row, y}, acc ->
          row
          |> String.split("", trim: true)
          |> Enum.with_index(1)
          |> Enum.reduce(acc, fn {tile, x}, acc ->
            case tile do
              " " -> acc
              tile -> Map.put(acc, {x, y}, tile)
            end
          end)
        end),
        Regex.split(~r/[LR]/, String.trim(moves), include_captures: true)
      }
    end).()
  end

  def walk({x,y}, dir) do
    case dir do
      :U -> {x, y-1}
      :D -> {x, y+1}
      :L -> {x-1, y}
      :R -> {x+1, y}
    end
  end

  def walk_edge({x,y}, dir, grid) do
    case dir do
      :U -> Enum.filter(grid, fn {{xx,_yy},_} -> x == xx end) |> Enum.max_by(fn {{_,yy},_} -> yy end)
      :D -> Enum.filter(grid, fn {{xx,_yy},_} -> x == xx end) |> Enum.min_by(fn {{_,yy},_} -> yy end)
      :L -> Enum.filter(grid, fn {{_xx,yy},_} -> y == yy end) |> Enum.max_by(fn {{xx,_},_} -> xx end)
      :R -> Enum.filter(grid, fn {{_xx,yy},_} -> y == yy end) |> Enum.min_by(fn {{xx,_},_} -> xx end)
    end
  end

  def get_face({x,y}) do
    cond do
      x in 0..50 -> cond do
        y in 101..150 -> 4
        y in 151..200 -> 6
      end
      x in 51..100 -> cond do
        y in 0..50 -> 1
        y in 51..100 -> 3
        y in 101..150 -> 5
      end
      x in 101..150 and y in 1..50 -> 2
    end
  end

  def walk_edge_part2({x,y}, dir, grid) do
    face = get_face({x,y})
    case face do
      1 ->
        case dir do
          :U -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 6 and rem(x,50) == rem(yy,50) end) |> Enum.min_by(fn {{xx,_},_} -> xx end), :R}
          :L -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 4 and 49 - rem(y - 1, 50) == rem(yy - 1, 50) end) |> Enum.min_by(fn {{xx,_},_} -> xx end), :R}
        end
      2 ->
        case dir do
          :U -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 6 and rem(x,50) == rem(xx,50) end) |> Enum.max_by(fn {{_,yy},_} -> yy end), :U}
          :R -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 5 and 49 - rem(y - 1, 50) == rem(yy - 1, 50) end) |> Enum.max_by(fn {{xx,_},_} -> xx end), :L}
          :D -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 3 and rem(x,50) == rem(yy,50) end) |> Enum.max_by(fn {{xx,_},_} -> xx end), :L}
        end
      3 ->
        case dir do
          :L -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 4 and rem(y,50) == rem(xx,50) end) |> Enum.min_by(fn {{_,yy},_} -> yy end), :D}
          :R -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 2 and rem(y,50) == rem(xx,50) end) |> Enum.max_by(fn {{_,yy},_} -> yy end), :U}
        end
      4 ->
        case dir do
          :U -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 3 and rem(x,50) == rem(yy,50) end) |> Enum.min_by(fn {{xx,_},_} -> xx end), :R}
          :L -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 1 and 49 - rem(y - 1, 50) == rem(yy - 1, 50) end) |> Enum.min_by(fn {{xx,_},_} -> xx end), :R}
        end
      5 ->
        case dir do
          :R -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 2 and 49 - rem(y - 1, 50) == rem(yy - 1, 50) end) |> Enum.max_by(fn {{xx,_},_} -> xx end), :L}
          :D -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 6 and rem(x,50) == rem(yy,50) end) |> Enum.max_by(fn {{xx,_},_} -> xx end), :L}
        end
      6 ->
        case dir do
          :D -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 2 and rem(x,50) == rem(xx,50) end) |> Enum.min_by(fn {{_,yy},_} -> yy end), :D}
          :R -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 5 and rem(y,50) == rem(xx,50) end) |> Enum.max_by(fn {{_,yy},_} -> yy end), :U}
          :L -> {Enum.filter(grid, fn {{xx,yy}, _} -> get_face({xx,yy}) == 1 and rem(y,50) == rem(xx,50) end) |> Enum.min_by(fn {{_,yy},_} -> yy end), :D}
        end
    end
  end

  def part1({grid, moves}, starting_pos) do
    Enum.reduce(moves, %{pos: starting_pos, dir: :R}, fn move, acc = %{pos: {x,y}, dir: dir} ->
      if move in ["L", "R"] do
        %{ acc | dir: (if move == "L", do: @turn_left[dir], else: @turn_right[dir]) }
      else
        move = String.to_integer(move)
        new_pos = Enum.reduce_while(1..move, {x,y}, fn _, pos ->
          new_pos = walk(pos, dir)
          {new_pos, tile} = if new_pos in Map.keys(grid), do: {new_pos, Map.get(grid, new_pos)}, else: walk_edge(pos, dir, grid)
          case tile do
            "#" -> {:halt, pos}
            _ -> {:cont, new_pos}
          end
        end)
        %{ acc | pos: new_pos }
      end
    end)
    |> (fn %{pos: {x,y}, dir: d} ->
      1000 * y + 4 * x + @dir_score[d]
    end).()
  end

  def part2({grid, moves}, starting_pos) do
    Enum.reduce(moves, %{pos: starting_pos, dir: :R}, fn move, acc = %{pos: {x,y}, dir: dir} ->
      if move in ["L", "R"] do
        %{ acc | dir: (if move == "L", do: @turn_left[dir], else: @turn_right[dir]) }
      else
        move = String.to_integer(move)
        {new_pos, new_dir} = Enum.reduce_while(1..move, {{x,y},dir}, fn _, {pos,dir} ->
          new_pos = walk(pos, dir)
          {{new_pos, tile}, new_dir} = if new_pos in Map.keys(grid), do: {{new_pos, Map.get(grid, new_pos)}, dir}, else: walk_edge_part2(pos, dir, grid)
          case tile do
            "#" -> {:halt, {pos, dir}}
            _ ->
              # IO.inspect({new_pos, get_face(new_pos)})
              {:cont, {new_pos, new_dir}}
          end
        end)
        %{ acc | pos: new_pos, dir: new_dir }
      end
    end)
    |> (fn %{pos: {x,y}, dir: d} ->
      1000 * y + 4 * x + @dir_score[d]
    end).()
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    starting_pos = Enum.min_by(elem(parsed_input,0), fn {{x,y},_} -> {y,x} end) |> elem(0)
    IO.inspect({starting_pos, get_face(starting_pos)})

    IO.inspect(part1(parsed_input, starting_pos), label: "Part 1")
    IO.inspect(part2(parsed_input, starting_pos), label: "Part 2")
  end
end
