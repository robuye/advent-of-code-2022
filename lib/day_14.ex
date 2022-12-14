defmodule AOC.Day14 do
  @input_path "data/day_14.txt"

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> expand_coordinates()
    |> flatten_all()
    |> drop_sand({500, 0})
  end

  def drop_sand(rocks, drop_from) do
    0..1000
    |> Enum.reduce_while({0, rocks}, fn _step, {idx, memo} ->
      new_rocks = make_next_move(memo, drop_from)

      if new_rocks == memo do
        {:halt, {idx, rocks}}
      else
        {:cont, {idx + 1, new_rocks}}
      end
    end)
    |> then(fn {count, _} -> count end)
  end

  def make_next_move(rocks, {sand_x, sand_y}) do
    go_down = {sand_x, sand_y + 1}
    go_left_down = {sand_x - 1, sand_y + 1}
    go_right_down = {sand_x + 1, sand_y + 1}

    max_y =
      rocks
      |> Enum.map(fn {_x, y} -> y end)
      |> Enum.max()

    next_pos =
      [
        go_down,
        go_left_down,
        go_right_down
      ]
      |> Enum.find(&(&1 not in rocks))

    # drop further if possible, otherwise settle and return new rocks
    cond do
      sand_y > max_y ->
        rocks

      next_pos ->
        make_next_move(rocks, next_pos)

      true ->
        [{sand_x, sand_y} | rocks]
    end
  end

  def flatten_all(data) do
    data
    |> Enum.flat_map(& &1)
    |> Enum.sort(fn {_, y1}, {_, y2} -> y1 < y2 end)
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
