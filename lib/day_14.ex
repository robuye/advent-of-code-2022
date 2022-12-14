defmodule AOC.Day14 do
  @input_path "data/day_14.txt"

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> expand_coordinates()
    |> to_map()
    |> drop_sand({500, 0})
  end

  def find_the_answer_p2() do
    stream_from_file()
    |> parse_input()
    |> add_floor_layer()
    |> expand_coordinates()
    |> to_map()
    |> drop_sand({500, 0})
  end

  def add_floor_layer(rocks) do
    max_y =
      rocks
      |> Enum.flat_map(& &1)
      |> Enum.map(fn {_x, y} -> y end)
      |> Enum.max()

    floor_line = [
      {300, max_y + 2},
      {700, max_y + 2}
    ]

    [floor_line | rocks]
  end

  def drop_sand(rocks, start_from) do
    rocks = rocks |> Map.put(:_path, [])

    max_y =
      rocks
      |> Map.drop([:_path])
      |> Map.keys()
      |> Enum.map(fn {_x, y} -> y end)
      |> Enum.max()

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({0, rocks}, fn step, {_idx, memo} ->
      drop_from = Enum.at(memo._path, 0) || start_from

      {op, new_rocks} =
        memo
        |> Map.update(:_path, [], fn path ->
          path
          |> List.delete_at(0)
        end)
        |> make_next_move(drop_from, max_y)

      {op, {step, new_rocks}}
    end)
    |> then(fn {count, _} -> count end)
  end

  def make_next_move(rocks, {sand_x, sand_y}, max_y) do
    sand = {sand_x, sand_y}

    go_down = {sand_x, sand_y + 1}
    go_left_down = {sand_x - 1, sand_y + 1}
    go_right_down = {sand_x + 1, sand_y + 1}

    next_pos =
      [
        go_down,
        go_left_down,
        go_right_down
      ]
      |> Enum.find(&(!Map.has_key?(rocks, &1)))

    cond do
      sand_y > max_y + 3 ->
        {:halt, rocks}

      next_pos ->
        rocks
        |> Map.update(:_path, [sand], fn prev -> [sand | prev] end)
        |> make_next_move(next_pos, max_y)

      !Map.has_key?(rocks, sand) ->
        new_rocks =
          rocks
          |> Map.put(sand, true)

        {:cont, new_rocks}

      true ->
        {:halt, rocks}
    end
  end

  def to_map(data) do
    data
    |> Enum.flat_map(& &1)
    |> Enum.map(&{&1, true})
    |> Enum.into(%{})
  end

  def expand_coordinates(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> Enum.reduce([], fn next_position, memo ->
        if memo == [] do
          [next_position]
        else
          fill_in(memo, next_position)
        end
      end)
    end)
  end

  def fill_in(memo, to) do
    from = Enum.at(memo, 0)

    {from_x, from_y} = from
    {to_x, to_y} = to

    distance_x = to_x - from_x
    distance_y = to_y - from_y

    new_points =
      cond do
        abs(distance_x) > 0 ->
          0..distance_x
          |> Enum.map(fn add_x -> {from_x + add_x, from_y} end)

        abs(distance_y) > 0 ->
          0..distance_y
          |> Enum.map(fn add_y -> {from_x, from_y + add_y} end)

        true ->
          [from, to]
      end

    new_points
    # first element is already in the memo
    |> Enum.drop(1)
    |> Enum.reduce(memo, fn new_point, prev_points ->
      [new_point | prev_points]
    end)
  end

  def parse_input(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.split(" -> ")
      |> Enum.map(fn coordinates ->
        [x, y] =
          coordinates
          |> String.split(",")

        {String.to_integer(x), String.to_integer(y)}
      end)
    end)
  end

  def stream_from_file(path \\ nil) do
    (path || @input_path)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end
end
