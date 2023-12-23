Mix.install([:nimble_parsec])

defmodule MyParser do
  import NimbleParsec

  def reduce_rule([wf]), do: wf
  def reduce_rule([rating, sign, value, wf]) do
    {{rating, sign, value}, wf}
  end

  def to_pair([wf | rules]) do
    {wf, rules}
  end

  wfname = ascii_string([?a..?z], min: 1) |> map({String, :to_atom, []})

  acc_rej = ascii_string([?A,?R], 1) |> map({String, :to_atom, []})

  rule =
    choice([
      acc_rej,
      ascii_string([?x,?m,?a,?s], 1)
      |> map({String, :to_atom, []})
      |> ascii_string([?<, ?>], 1)
      |> integer(min: 1)
      |> ignore(ascii_char([?:]))
      |> choice([acc_rej, wfname]),
      wfname
    ])
    |> reduce(:reduce_rule)

  rules =
    rule
    |> repeat(
      ignore(string(","))
      |> concat(rule)
    )

  workflow =
    wfname
    |> ignore(string("{"))
    |> concat(rules)
    |> ignore(string("}"))
    |> reduce(:to_pair)

  rating =
    ascii_string([?x,?m,?a,?s], 1)
    |> map({String, :to_atom, []})
    |> ignore(ascii_char([?=]))
    |> integer(min: 1)
    |> reduce({List, :to_tuple, []})

  part =
    ignore(string("{"))
    |> concat(rating)
    |> repeat(
      ignore(string(","))
      |> concat(rating))
    |> ignore(string("}"))
    |> reduce({Map, :new, []})

  defparsec :workflows, workflow |> repeat(ignore(string("\n")) |> concat(workflow)) |> reduce({Map, :new, []})
  defparsec :parts, part |> repeat(ignore(string("\n")) |> concat(part))
end

defmodule Day_19 do
  def parse_input(filename) do
    File.read!(filename)
    |> String.split("\n\n")
    |> then(fn [wfs, parts] ->
      %{
        workflows: MyParser.workflows(wfs) |> elem(1) |> hd(),
        parts: MyParser.parts(parts) |> elem(1)
      }
    end)
  end

  def check(part, {{rating, sign, value}, wf}) do
    op = case sign do
      ">" -> & Kernel.>/2
      "<" -> & Kernel.</2
    end
    if op.(Map.get(part, rating), value), do: wf, else: nil
  end
  def check(_part, wf), do: wf

  def part1(input) do
    Enum.map(input.parts, fn part ->
      Enum.reduce_while(Stream.iterate(0, & &1+1), :in, fn _, acc ->
        Enum.reduce_while(Map.get(input.workflows, acc), nil, fn condition, _ ->
          case check(part, condition) do
            nil -> {:cont, nil}
            x -> {:halt, x}
          end
        end)
        |> case do
          :A -> {:halt, :A}
          :R -> {:halt, :R}
          x -> {:cont, x}
        end
      end)
      |> case do
        :A -> Map.values(part) |> Enum.sum()
        :R -> 0
      end
    end)
    |> Enum.sum()
  end

  def build_tree(_workflows, [:A]), do: :A
  def build_tree(_workflows, [:R]), do: :R
  def build_tree( workflows,  [x]), do: build_tree(workflows, workflows[x])
  def build_tree( workflows, [ {a,x} | t ]) do
    %{
      node: a,
      left: (case x, do: (:A -> :A; :R -> :R; _ -> build_tree(workflows, workflows[x]))),
      right: build_tree(workflows, t)
    }
  end

  def produce_values("<", v), do: {MapSet.new(1..v-1), MapSet.new(v..4000)}
  def produce_values(">", v), do: {MapSet.new(v+1..4000), MapSet.new(1..v)}

  def navigate_tree(:A, values), do: Enum.map(values, fn {k, v} -> MapSet.size(v) end) |> Enum.product()
  def navigate_tree(:R, values), do: 0
  def navigate_tree(%{node: {rating, sign, value}, left: left, right: right}, values) do
    {lv, rv} = produce_values(sign, value)
    l = navigate_tree(left, Map.update!(values, rating, & MapSet.intersection(&1, lv)))
    r = navigate_tree(right, Map.update!(values, rating, & MapSet.intersection(&1, rv)))
    l + r
  end

  def part2(input) do
    build_tree(input.workflows, input.workflows.in)
    |> navigate_tree(%{
      x: MapSet.new(1..4000),
      m: MapSet.new(1..4000),
      a: MapSet.new(1..4000),
      s: MapSet.new(1..4000)
    })
  end

  def main do
    filename = Enum.at(System.argv, 0, "input.txt")
    parsed_input = parse_input(filename)

    IO.inspect(part1(parsed_input), label: "Part 1")
    IO.inspect(part2(parsed_input), label: "Part 2")
  end
end

Day_19.main()
