defmodule AOC.Day9 do
  @input_path "data/day_9.txt"

  import Stream, only: [map: 2]

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> play_the_game()
    |> calculate_tail_visited_locations()
  end

  def calculate_tail_visited_locations(state) do
    state.tail_visited
    |> MapSet.new()
    |> MapSet.size()
  end

  def play_the_game(moves) do
    state = %{
      head: {0, 0},
      tail: {0, 0},
      tail_visited: [{0, 0}]
    }

    moves
    |> Enum.reduce(state, fn {direction, times}, acc ->
      1..times
      |> Enum.reduce(acc, fn _, inner_acc ->
        make_a_move(direction, inner_acc)
      end)
    end)
  end

  def make_a_move(direction, state) do
    {x, y} = state.head

    x_move =
      case direction do
        "L" -> -1
        "R" -> 1
        _ -> 0
      end

    y_move =
      case direction do
        "U" -> 1
        "D" -> -1
        _ -> 0
      end

    head_after_move = {x + x_move, y + y_move}

    tail_after_move = pull_in_tail(state.tail, head_after_move)

    state
    |> Map.put(:head, head_after_move)
    |> Map.put(:tail, tail_after_move)
    |> Map.get_and_update(:tail_visited, fn visited ->
      if tail_after_move == state.tail,
        do: {visited, visited},
        else: {visited, [tail_after_move | visited]}
    end)
    |> then(fn {_old, new} -> new end)
  end

  def pull_in_tail(tail, head_after_move) do
    {t_x, t_y} = tail
    {h_x, h_y} = head_after_move

    x_distance = h_x - t_x
    y_distance = h_y - t_y

    x_move =
      case x_distance do
        0 -> 0
        n when n < 0 -> -1
        n when n > 0 -> 1
      end

    y_move =
      case y_distance do
        0 -> 0
        n when n < 0 -> -1
        n when n > 0 -> 1
      end

    if abs(x_distance) > 1 || abs(y_distance) > 1 do
      {t_x + x_move, t_y + y_move}
    else
      {t_x, t_y}
    end
  end

  def parse_input(lines) do
    lines
    |> map(fn line ->
      [dir, count] =
        line
        |> String.split(" ")

      {dir, String.to_integer(count)}
    end)
    |> Enum.to_list()
  end

  def stream_from_file() do
    File.stream!(@input_path)
    |> map(&String.trim/1)
  end
end
