defmodule Mix.Tasks.Main do
  use Mix.Task

  def run(_) do
    IO.inspect(div(:timer.tc(Day_18, :main, []) |> elem(0),1000), label: "Time (mSecs)")
  end
end
