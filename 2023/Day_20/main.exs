Mix.install([:graphvix])

defmodule Day_20 do
  alias Graphvix.Graph

  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(& Regex.run(~r/([&%])?(\w+) -> (\w+(?:, \w+)*)/, &1) |> tl())
    |> Enum.reduce(%{}, fn line = [_, module, dests], acc ->
      name = String.to_atom(module)
      destinations = String.split(dests, ", ") |> Enum.map(&String.to_atom/1)
      case line do
        ["", "broadcaster", _] -> Map.update(acc, :broadcaster, %{type: :broadcaster, destinations: destinations}, & %{&1 | type: :broadcaster, destinations: destinations})
        ["%" | _] -> Map.update(acc, name, %{type: :flipflop, destinations: destinations}, & %{&1 | type: :flipflop, destinations: destinations})
        ["&" | _] -> Map.update(acc, name, %{type: :conjunction, destinations: destinations}, & %{&1 | type: :conjunction, destinations: destinations})
      end
    end)
    |> then(fn modules ->
      Enum.reduce(modules, modules, fn {name, %{destinations: destinations}}, acc ->
        Enum.reduce(destinations, acc, fn dest, accc ->
          if dest in Map.keys(accc) do
            case Map.get(accc, dest).type do
              :conjunction ->
                Map.update!(accc, dest, fn x ->
                  Map.update(x, :inputs, %{name => :low}, & Map.put(&1, name, :low))
                end)
              :flipflop -> Map.update!(accc, dest, & Map.put(&1, :state, :off))
              _ -> accc
            end
          else
            Map.put(accc, dest, %{type: nil})
          end
        end)
      end)
    end)
  end

  def flip_state(:off), do: :on
  def flip_state(:on), do: :off

  def part1(input) do
    Enum.reduce_while(Stream.iterate(0, & &1 + 1), {input, %{low: 0, high: 0}}, fn i, {state, pulses} ->
      {new_state, new_pulses} = Enum.reduce_while(Stream.iterate(0, & &1 + 1), {state, [{:button, :low, :broadcaster}], %{low: 0, high: 0}}, fn
        _, {modules, [], pulses} -> {:halt, {modules, pulses}}
        _, {modules, [{source, pulse, dest} | signals], pulses} ->
          new_pulses = Map.update!(pulses, pulse, & &1 + 1)
          dest_module = Map.get(modules, dest)
          case dest_module do
            %{type: :broadcaster, destinations: destinations} ->
              {:cont, {modules, signals ++ Enum.map(destinations, & {:broadcaster, pulse, &1}), new_pulses}}
            %{type: :flipflop, destinations: destinations} ->
              if pulse == :high do
                {:cont, {modules, signals, new_pulses}}
              else
                current_state = flip_state(dest_module.state)
                signal_pulse = if current_state == :on, do: :high, else: :low
                {:cont, {Map.update!(modules, dest, & Map.put(&1, :state, current_state)), signals ++ Enum.map(destinations, & {dest, signal_pulse, &1}), new_pulses}}
              end
            %{type: :conjunction, destinations: destinations} ->
              new_inputs = Map.put(dest_module.inputs, source, pulse)
              if Map.values(new_inputs) |> Enum.all?(& &1 == :high) do
                {:cont, {Map.update!(modules, dest, & Map.put(&1, :inputs, new_inputs)), signals ++ Enum.map(destinations, & {dest, :low, &1}), new_pulses}}
              else
                {:cont, {Map.update!(modules, dest, & Map.put(&1, :inputs, new_inputs)), signals ++ Enum.map(destinations, & {dest, :high, &1}), new_pulses}}
              end
            %{type: nil} -> {:cont, {modules, signals, new_pulses}}
          end
      end)
      if input == new_state or i == 999 do
        {:halt, {i + 1, pulses.high + new_pulses.high, pulses.low + new_pulses.low}}
      else
        {:cont, {new_state, %{high: pulses.high + new_pulses.high, low: pulses.low + new_pulses.low}}}
      end
    end)
    |> then(fn {i, highs, lows} ->
      n = div(1000, i)
      highs * n * lows * n
    end)
  end

  def get_type(modules, module), do: modules[module].type

  def type_to_string(:flipflop), do: "%"
  def type_to_string(:conjunction), do: "&"

  def part2(input) do
    graph = Graph.new()
    {graph, vertex_bc_id} = Graph.add_vertex(graph, "broadcaster")
    {graph, vertices} = Enum.reduce(input.broadcaster.destinations, {graph, %{broadcaster: vertex_bc_id}}, fn dest, {graph, vertices} ->
      {graph, vertex_id} = Graph.add_vertex(graph, type_to_string(get_type(input, dest)) <> to_string(dest))
      {graph, _} = Graph.add_edge(graph, vertex_bc_id, vertex_id)
      {graph, Map.put(vertices, dest, vertex_id)}
    end)
    graph = Enum.reduce_while(Stream.iterate(0, & &1 + 1), %{
      vertices: vertices,
      visited: MapSet.new([:broadcaster]),
      queue: input.broadcaster.destinations,
      graph: graph
    }, fn _, acc ->
      if length(acc.queue) == 0 do
        {:halt, acc.graph}
      else
        [h | t] = acc.queue
        destinations = Map.get(input[h], :destinations, []) |> Enum.filter(& &1 not in Map.keys(acc.vertices))
        new_queue = t ++ destinations
        src_vertex_id = acc.vertices[h]
        {new_graph, new_vertices} = Enum.reduce(destinations, {acc.graph, acc.vertices}, fn dest, {graph, vertices} ->
          type = get_type(input, dest)
          {graph, new_vertex} =
            cond do
              dest == :rx -> Graph.add_vertex(graph, "rx", color: "red", shape: "diamond")
              type == :flipflop -> Graph.add_vertex(graph, type_to_string(type) <> to_string(dest))
              true -> Graph.add_vertex(graph, type_to_string(type) <> to_string(dest), color: "blue")
            end
          {graph, Map.put(vertices, dest, new_vertex)}
        end)
        new_graph = Enum.reduce(Map.get(input[h], :destinations, []), new_graph, fn dest, graph ->
          {graph, _} = Graph.add_edge(graph, src_vertex_id, new_vertices[dest])
          graph
        end)
        new_visited = MapSet.put(acc.visited, h)
        {:cont, %{
          vertices: new_vertices,
          visited: new_visited,
          queue: new_queue,
          graph: new_graph,
        }}
      end
    end)

    Graph.compile(graph, "graph")

    # After generating the graph, one can see that the pulse sent to 'rx' depends on the state
    # of the conjunction 'jz', which in turn depends on the state of the conjunctions 'rn', 'mk', 'dh' and 'vf'.
    # These conjunctions, on the other hand, are just inverters for the conjunctions 'zt', 'jg', 'pn' and 'qx'.
    # Therefore, when all of these four conjunctions send a low pulse at the same time, 'rx' will receive a low
    # pulse, we just need to find the right iteration.
    # All of the four conjunctions are part of their own loop, so we just need to press the button until we
    # find the size of each of the four loops.

    Enum.reduce_while(Stream.iterate(0, & &1 + 1), {input, []}, fn i, {state, cycles} ->
      {new_state, cycles} = Enum.reduce_while(Stream.iterate(0, & &1 + 1), {state, [{:button, :low, :broadcaster}], cycles}, fn
        _, {modules, [], cycles} -> {:halt, {modules, cycles}}
        _, {modules, [{source, pulse, dest} | signals], cycles} ->
          new_cycles = case {pulse, dest} do
            {:low, :rn} -> [ i + 1 | cycles ]
            {:low, :mk} -> [ i + 1 | cycles ]
            {:low, :dh} -> [ i + 1 | cycles ]
            {:low, :vf} -> [ i + 1 | cycles ]
            _ -> cycles
          end
          dest_module = Map.get(modules, dest)
          case dest_module do
            %{type: :broadcaster, destinations: destinations} ->
              {:cont, {modules, signals ++ Enum.map(destinations, & {:broadcaster, pulse, &1}), new_cycles}}
            %{type: :flipflop, destinations: destinations} ->
              if pulse == :high do
                {:cont, {modules, signals, new_cycles}}
              else
                current_state = flip_state(dest_module.state)
                signal_pulse = if current_state == :on, do: :high, else: :low
                {:cont, {Map.update!(modules, dest, & Map.put(&1, :state, current_state)), signals ++ Enum.map(destinations, & {dest, signal_pulse, &1}), new_cycles}}
              end
            %{type: :conjunction, destinations: destinations} ->
              new_inputs = Map.put(dest_module.inputs, source, pulse)
              if Map.values(new_inputs) |> Enum.all?(& &1 == :high) do
                {:cont, {Map.update!(modules, dest, & Map.put(&1, :inputs, new_inputs)), signals ++ Enum.map(destinations, & {dest, :low, &1}), new_cycles}}
              else
                {:cont, {Map.update!(modules, dest, & Map.put(&1, :inputs, new_inputs)), signals ++ Enum.map(destinations, & {dest, :high, &1}), new_cycles}}
              end
            %{type: nil} -> {:cont, {modules, signals, new_cycles}}
          end
      end)

      if length(cycles) == 4 do
        {:halt, cycles}
      else
        {:cont, {new_state, cycles}}
      end
    end)
    |> Enum.product()
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    if filename == "input.txt", do: IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_20.main()
