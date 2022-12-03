defmodule AOC.Day1.Test do
  use ExUnit.Case

  test "chunk_by_elf/1" do
    input = [1, 2, 3, nil, 4, 5, 6, nil, 7, 3, nil, 8]

    output =
      input
      |> AOC.Day1.chunk_by_elf()
      |> Enum.to_list()

    assert output == [
      [1, 2, 3],
      [4, 5, 6],
      [7, 3],
      [8]
    ]
  end

  test "sum_up_cals/1" do
    input = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 3],
      [8]
    ]

    output =
      input
      |> AOC.Day1.sum_up_cals()
      |> Enum.to_list()

    assert output == [
      6,
      15,
      10,
      8
    ]
  end

  test "get_most_cals/1" do
    input = [6, 15, 15, 10, 8]

    output =
      input
      |> AOC.Day1.get_most_cals()

    assert output == 15
  end

  test "get_sum_of_top_3/1" do
    input = [6, 15, 15, 10, 8]

    output =
      input
      |> AOC.Day1.get_sum_of_top_3()

    assert output == 40
  end
end
