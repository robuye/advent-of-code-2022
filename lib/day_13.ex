defmodule AOC.Day13 do
  @input_path "data/day_13.txt"

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> chunk_by_two()
    |> validate_pairs()
    |> sum_valid_indices()
  end

  def find_the_answer_p2() do
    stream_from_file()
    |> parse_input()
    |> add_dividers()
    |> sort_packets()
    |> multiply_divider_indices()
  end

  def multiply_divider_indices(data) do
    data
    |> Enum.with_index()
    |> Enum.filter(fn
      {[2], _} -> true
      {[6], _} -> true
      _ -> false
    end)
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.product()
  end

  def add_dividers(data) do
    data ++ [[2]] ++ [[6]]
  end

  def sort_packets(data) do
    data
    |> Enum.sort(fn a, b ->
      compare_values(a, b)
      |> case do
        nil -> true
        other -> other
      end
    end)
  end

  def sum_valid_indices(results) do
    results
    |> Enum.with_index()
    |> Enum.filter(fn {is_valid, _idx} -> is_valid end)
    |> Enum.map(fn {_is_valid, idx} -> idx + 1 end)
    |> Enum.sum()
  end

  def validate_pairs(data) do
    data
    |> Enum.map(fn {a, b} -> compare_values(a, b) end)
  end

  def compare_values(a, b) when is_integer(a) and is_list(b) do
    compare_values([a], b)
  end

  def compare_values(a, b) when is_list(a) and is_integer(b) do
    compare_values(a, [b])
  end

  def compare_values(_a, nil), do: false

  def compare_values(nil, _b), do: true

  def compare_values([_ | _], []), do: false

  def compare_values([], [_ | _]), do: true

  def compare_values([], []), do: nil

  def compare_values(a, b) when is_list(a) and is_list(b) do
    [a_head | a_rest] = a
    [b_head | b_rest] = b

    case compare_values(a_head, b_head) do
      nil -> compare_values(a_rest, b_rest)
      other -> other
    end
  end

  def compare_values(a, b) when is_integer(a) and is_integer(b) do
    cond do
      a < b -> true
      a > b -> false
      a == b -> nil
    end
  end

  def parse_input(lines) do
    lines
    |> Enum.map(fn line ->
      {result, _bindings} = Code.eval_string(line)
      result
    end)
  end

  def chunk_by_two(items) do
    items
    |> Enum.chunk_every(2)
    |> Enum.map(fn [lhs, rhs] -> {lhs, rhs} end)
  end

  def stream_from_file(path \\ nil) do
    (path || @input_path)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> Enum.to_list()
  end
end
