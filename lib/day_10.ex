defmodule AOC.Day10 do
  @input_path "data/day_10.txt"

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> run_instructions()
    |> sum_up_strength_readings()
  end

  def find_the_answer_p2() do
    stream_from_file()
    |> parse_input()
    |> run_instructions()
    |> get_crt_screen()
  end

  def sum_up_strength_readings(state) do
    state.signal_strength_readings
    |> Map.values()
    |> Enum.sum()
  end

  def get_crt_screen(state) do
    state.crt_pixels
    |> Map.values()
    |> Enum.map(fn line -> Enum.join(line, "") end)
  end

  def run_instructions(commands) do
    initial_state = %{
      x: 1,
      global_cycle: 1,
      signal_strength_readings: %{},
      crt_pixels: %{}
    }

    commands
    |> Enum.reduce(initial_state, fn op, outer_state ->
      1..op.cost
      |> Enum.reduce(outer_state, fn op_cycle, inner_state ->
        inner_state
        |> record_signal_str()
        |> render_crt_pixel()
        |> run_cycle(op, op_cycle)
        |> Map.put(:global_cycle, inner_state.global_cycle + 1)
      end)
    end)
  end

  def render_crt_pixel(%{global_cycle: cycle} = state) do
    line_pos = div(cycle - 1, 40)
    x_pos = rem(cycle - 1, 40)

    sprite = Range.new(state.x - 1, state.x + 1)
    pixel = if(Enum.member?(sprite, x_pos), do: "#", else: ".")

    state
    |> Map.update(:crt_pixels, %{}, fn crt_pixels ->
      crt_pixels
      |> Map.update(line_pos, [pixel], fn line_pixels ->
        line_pixels
        |> List.insert_at(-1, pixel)
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
