defmodule AOC.Day9 do
  @input_path "data/day_9.txt"

  import Stream, only: [map: 2]

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> play_the_game(1)
    |> calculate_tail_visited_locations(1)
  end

  def find_the_answer_p2() do
    stream_from_file()
    |> parse_input()
    |> play_the_game(9)
    |> calculate_tail_visited_locations(9)
  end

  def calculate_tail_visited_locations(state, tail_num) do
    state.tails_visited
    |> Map.get(tail_num, [{0, 0}])
    |> MapSet.new()
    |> MapSet.size()
  end

  def play_the_game(moves, tails_num \\ 1) do
    state = %{
      head: {0, 0},
      tails_num: tails_num,
      tails_visited: %{}
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
    tails_after_move = pull_all_tails(state, head_after_move)

    state
    |> Map.put(:head, head_after_move)
    |> Map.update(:tails_visited, %{}, fn prev_tails ->
      Map.merge(prev_tails, tails_after_move)
    end)
  end

  def pull_all_tails(state, head_after_move) do
    1..state.tails_num
    |> Enum.reduce_while(state.tails_visited, fn num, acc ->
      history = Map.get(acc, num, [{0, 0}])

      last_pos = List.first(history)

      pull_to =
        if(num == 1,
          do: head_after_move,
          else: Map.get(acc, num - 1) |> List.first()
        )

      new_pos = pull_in_tail(last_pos, pull_to)

      if last_pos == new_pos do
        {:halt, acc}
      else
        {:cont, Map.put(acc, num, [new_pos | history])}
      end
    end)
  end

  def pull_in_tail(tail, pull_to) do
    {t_x, t_y} = tail
    {h_x, h_y} = pull_to

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
