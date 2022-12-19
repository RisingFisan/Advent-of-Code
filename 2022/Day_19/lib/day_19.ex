defmodule Day_19 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/\d+/, line)
      |> Enum.concat
      |> Enum.map(&String.to_integer/1)
      |> (fn [index, ore_cost_ore, clay_cost_ore, obsidian_cost_ore, obsidian_cost_clay, geode_cost_ore, geode_cost_obsidian] ->
        %{index: index,
          ore_cost_ore: ore_cost_ore,
          clay_cost_ore: clay_cost_ore,
          obsidian_cost_ore: obsidian_cost_ore,
          obsidian_cost_clay: obsidian_cost_clay,
          geode_cost_ore: geode_cost_ore,
          geode_cost_obsidian: geode_cost_obsidian}
      end).()
    end)
  end

  def mine_ore(%{ore: ore, ore_robots: ore_robots} = state) do
    %{state | ore: ore + ore_robots}
  end

  def mine_clay(%{clay: clay, clay_robots: clay_robots} = state) do
    %{state | clay: clay + clay_robots}
  end

  def mine_obsidian(%{obsidian: obsidian, obsidian_robots: obsidian_robots} = state) do
    %{state | obsidian: obsidian + obsidian_robots}
  end

  def mine_geode(%{geode: geode, geode_robots: geode_robots} = state) do
    %{state | geode: geode + geode_robots}
  end

  def possible_to_build(state, blueprint) do
    cond do
      state.ore >= blueprint.geode_cost_ore and state.obsidian >= blueprint.geode_cost_obsidian -> [:geode]
      state.ore >= blueprint.obsidian_cost_ore and state.clay >= blueprint.obsidian_cost_clay -> [:obsidian] ++ (if state.ore >= blueprint.clay_cost_ore, do: [:clay], else: [])
      state.ore >= blueprint.clay_cost_ore ->
        if state.ore >= blueprint.ore_cost_ore and state.clay + state.clay_robots < blueprint.obsidian_cost_clay do
          [:ore, :clay]
        else
          [:clay, :nothing]
        end
      state.ore >= blueprint.ore_cost_ore -> [:ore]
      true -> [:nothing]
    end
  end

  def process_state(state, 0, _), do: [ state ]
  def process_state(state, time, blueprint) do
    new_state = state
    |> mine_ore()
    |> mine_clay()
    |> mine_obsidian()
    |> mine_geode()

    for build <- possible_to_build(state, blueprint) do
      case build do
        :ore -> %{new_state | ore_robots: new_state.ore_robots + 1, ore: new_state.ore - blueprint.ore_cost_ore}
        :clay -> %{new_state | clay_robots: new_state.clay_robots + 1, ore: new_state.ore - blueprint.clay_cost_ore}
        :obsidian -> %{new_state | obsidian_robots: new_state.obsidian_robots + 1, ore: new_state.ore - blueprint.obsidian_cost_ore, clay: new_state.clay - blueprint.obsidian_cost_clay}
        :geode -> %{new_state | geode_robots: new_state.geode_robots + 1, ore: new_state.ore - blueprint.geode_cost_ore, obsidian: new_state.obsidian - blueprint.geode_cost_obsidian}
        :nothing -> new_state
      end
      |> process_state(time - 1, blueprint)
    end
    |> Enum.max_by(& hd(&1).geode)
    |> (fn x ->
      if state.ore_robots == 1 and state.ore == 0, do: IO.puts("Blueprint #{hd(x).index} finished with #{hd(x).geode} geodes.")
      x ++ [state]
    end).()
  end

  def part1(blueprints) do
    for blueprint <- blueprints do
      initial_state = %{
        index: blueprint.index,
        ore: 0,
        clay: 0,
        obsidian: 0,
        geode: 0,
        ore_robots: 1,
        clay_robots: 0,
        obsidian_robots: 0,
        geode_robots: 0
      }
      Task.async(fn -> process_state(initial_state, 24, blueprint) end)
    end
    |> Task.await_many(:infinity)
    |> Enum.map(& hd(&1).index * hd(&1).geode)
    |> Enum.sum
  end

  def part2(blueprints) do
    for blueprint <- blueprints |> Enum.take(3) do
      initial_state = %{
        index: blueprint.index,
        ore: 0,
        clay: 0,
        obsidian: 0,
        geode: 0,
        ore_robots: 1,
        clay_robots: 0,
        obsidian_robots: 0,
        geode_robots: 0
      }
      Task.async(fn -> process_state(initial_state, 32, blueprint) end)
    end
    |> Task.await_many(:infinity)
    |> Enum.map(& hd(&1).geode)
    |> Enum.product
  end

  def main do
    filename = Enum.at(System.argv, 1, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end
