defmodule AOC.Day6 do
  @input_path "data/day_6.txt"

  def find_the_answer_p1(stream \\ nil) do
    (stream || read_from_file())
    |> String.to_charlist()
    |> find_unique_four_idx()
    |> add_one()
  end

  def add_one(n), do: n + 1

  def find_unique_four_idx(data) do
    data
    |> Enum.reduce_while(3, fn _char, acc_idx ->
      data
      |> get_last_four(acc_idx)
      |> count_unique()
      |> case do
        4 -> {:halt, acc_idx}
        _ -> {:cont, acc_idx + 1}
      end
    end)
  end

  def count_unique(list) do
    MapSet.new(list)
    |> MapSet.size()
  end

  def get_last_four(chars, cursor_pos) do
    chars
    |> Enum.slice(cursor_pos - 3, 4)
  end

  def read_from_file() do
    File.read!(@input_path)
  end
end
