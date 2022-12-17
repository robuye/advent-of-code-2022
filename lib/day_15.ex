defmodule AOC.Day15 do
  @input_path "data/day_15.txt"

  def find_the_answer_p1(y) do
    stream_from_file()
    |> parse_input()
    |> expand_sensors_coverage()
    |> render_coverage_at(y)
  end

  def render_coverage_at(sensors, y) do
    beacons_at_y =
      sensors
      |> Enum.filter(&(&1.by == y))
      |> Enum.map(& &1.bx)
      |> MapSet.new()

    sensors
    |> Enum.filter(&Enum.member?(&1.coverage_y, y))
    |> Enum.reduce(MapSet.new([]), fn sensor, memo ->
      y_distance = abs(sensor.sy - y)
      x_distance = sensor.strength - y_distance

      line_coverage =
        Range.new(
          sensor.sx - x_distance,
          sensor.sx + x_distance
        )
        |> MapSet.new()
        |> MapSet.difference(beacons_at_y)

      MapSet.union(memo, line_coverage)
    end)
  end

  def expand_sensors_coverage(sensors_data) do
    sensors_data
    |> Enum.map(fn sensor ->
      max_distance = abs(sensor.bx - sensor.sx) + abs(sensor.by - sensor.sy)

      coverage_y =
        Range.new(
          sensor.sy - max_distance,
          sensor.sy + max_distance
        )

      sensor
      |> Map.put(:strength, max_distance)
      |> Map.put(:coverage_y, coverage_y)
    end)
  end

  def parse_input(lines) do
    lines
    |> Enum.map(fn input ->
      ~r/Sensor at x=(?<sx>-?\d+), y=(?<sy>-?\d+): closest beacon is at x=(?<bx>-?\d+), y=(?<by>-?\d+)/
      |> Regex.named_captures(input)
      |> Enum.map(fn {k, v} ->
        {String.to_atom(k), String.to_integer(v)}
      end)
      |> Enum.into(%{})
    end)
  end

  def stream_from_file(path \\ nil) do
    (path || @input_path)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end
end
