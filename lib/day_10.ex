defmodule AOC.Day10 do
  @input_path "data/day_10.txt"

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> run_instructions()
    |> sum_up_strength_readings()
  end

  def sum_up_strength_readings(state) do
    state.signal_strength_readings
    |> Map.values()
    |> Enum.sum()
  end

  def run_instructions(commands) do
    initial_state = %{
      x: 1,
      global_cycle: 1,
      signal_strength_readings: %{}
    }

    commands
    |> Enum.reduce(initial_state, fn op, outer_state ->
      1..op.cost
      |> Enum.reduce(outer_state, fn op_cycle, inner_state ->
        inner_state
        |> record_signal_str()
        |> run_cycle(op, op_cycle)
        |> Map.put(:global_cycle, inner_state.global_cycle + 1)
      end)
    end)
  end

  def record_signal_str(%{global_cycle: g_c} = state)
      when rem(g_c + 20, 40) == 0 do
    state
    |> Map.update(:signal_strength_readings, %{}, fn data ->
      Map.put(data, g_c, state.x * g_c)
    end)
  end

  def record_signal_str(state) do
    state
  end

  def run_cycle(state, %{op: :addx} = op, op_cycle) do
    if op_cycle == op.cost do
      val =
        List.first(op.args)
        |> String.to_integer()

      state
      |> Map.put(:x, state.x + val)
    else
      state
    end
  end

  def run_cycle(state, %{op: :noop}, _cycle) do
    state
  end

  def parse_input(lines) do
    lines
    |> Stream.map(fn line ->
      [op | args] = String.split(line, " ")

      operation = String.to_existing_atom(op)

      %{
        op: operation,
        args: args,
        cost: get_cost(operation)
      }
    end)
    |> Enum.to_list()
  end

  defp get_cost(:noop), do: 1
  defp get_cost(:addx), do: 2

  def stream_from_file(path \\ nil) do
    (path || @input_path)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end
