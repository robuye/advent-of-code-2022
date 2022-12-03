defmodule AOC.Day1 do
  @input_path "data/day_1.txt"

  import Stream, only: [
    chunk_by: 2,
    reject: 2,
    map: 2
  ]

  def find_the_answer_p1() do
    stream_from_file()
    |> chunk_by_elf()
    |> sum_up_cals()
    |> get_most_cals()
  end

  def stream_from_file() do
    File.stream!(@input_path)
    |> map(&String.trim/1)
    |> map(fn
      "" -> nil
      str when is_binary(str) -> String.to_integer(str)
      num -> num
    end)
  end

  def chunk_by_elf(foods_cals) do
    foods_cals
    |> chunk_by(&is_nil/1)
    |> reject(& &1 == [nil])
  end

  def sum_up_cals(foods_cals) do
    foods_cals
    |> map(&Enum.sum/1)
  end

  def get_most_cals(summed_cals) do
    summed_cals
    |> Enum.max()
  end
end
