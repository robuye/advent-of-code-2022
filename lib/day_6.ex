defmodule AOC.Day6 do
  @input_path "data/day_6.txt"

  def find_the_answer_p1(stream \\ nil) do
    (stream || read_from_file())
    |> String.to_charlist()
    |> find_unique_n_characters_idx(4)
  end

  def find_the_answer_p2(stream \\ nil) do
    (stream || read_from_file())
    |> String.to_charlist()
    |> find_unique_n_characters_idx(14)
  end

  def find_unique_n_characters_idx(data, num_chars) do
    data
    |> Enum.reduce_while(num_chars - 1, fn _char, acc_idx ->
      data
      |> get_last_n(acc_idx, num_chars)
      |> count_unique()
      |> case do
        ^num_chars -> {:halt, acc_idx}
        _ -> {:cont, acc_idx + 1}
      end
    end)
  end

  def count_unique(list) do
    MapSet.new(list)
    |> MapSet.size()
  end

  def get_last_n(chars, cursor_pos, num_to_take) do
    start_at = cursor_pos - num_to_take

    chars
    |> Enum.slice(start_at, num_to_take)
  end

  def read_from_file() do
    File.read!(@input_path)
  end
end
