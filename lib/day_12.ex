defmodule AOC.Day12 do
  @input_path "data/day_12.txt"

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> play_the_game()
    |> then(& &1.step)
  end

  def play_the_game(board) do
    {start_at, complete_at} = find_start_end(board)

    initial_state = %{
      queue: MapSet.new([start_at]),
      visited: MapSet.new([]),
      steps: 0
    }

    1..10000
    |> Enum.reduce_while(initial_state, fn layer, state ->
      next_candidates = plan_next_moves(board, state.queue, state.visited)

      new_state = %{
        queue: MapSet.new(next_candidates),
        visited: MapSet.union(state.visited, state.queue),
        step: layer
      }

      if Enum.member?(next_candidates, complete_at) do
        {:halt, new_state}
      else
        {:cont, new_state}
      end
    end)
  end

  def find_start_end(board) do
    {
      Enum.find(board, & &1.is_starting),
      Enum.find(board, & &1.is_ending)
    }
  end

  def plan_next_moves(board, queue, visited) do
    queue
    |> Enum.reduce([], fn move, memo ->
      candidates =
        board
        |> get_neightboors(move.position)
        |> reject_higher_than(move.height + 1)
        |> Enum.reject(&Enum.member?(visited, &1))

      memo ++ candidates
    end)
  end

  def get_neightboors(board, {x, y}) do
    l = {x - 1, y}
    r = {x + 1, y}
    t = {x, y + 1}
    b = {x, y - 1}

    [l, r, t, b]
    |> Enum.map(fn position ->
      Enum.find(board, &(&1.position == position))
    end)
    |> Enum.reject(&is_nil/1)
  end

  def reject_higher_than(list, max_height) do
    list
    |> Enum.reject(&(&1.height > max_height))
  end

  def parse_input(data) do
    data
    |> Enum.with_index(&{&1, &2 * -1})
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        %{
          char: char,
          height: get_height(char),
          is_starting: char == "S",
          is_ending: char == "E",
          position: {x, y}
        }
      end)
    end)
  end

  def get_height("S"), do: get_height("a")
  def get_height("E"), do: get_height("z")
  def get_height(chr), do: :binary.first(chr)

  def stream_from_file(path \\ nil) do
    (path || @input_path)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end
end
