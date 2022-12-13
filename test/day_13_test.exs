defmodule AOC.Day13.Test do
  use ExUnit.Case

  import AOC.Day13

  @input [
    ~s([1, 1, 3, 1, 1]),
    ~s([1, 1, 5, 1, 1]),
    ~s([[1], [2, 3, 4]]),
    ~s([[1], 4]),
    ~s([9]),
    ~s([[8, 7, 6]]),
    ~s([[4, 4], 4, 4]),
    ~s([[4, 4], 4, 4, 4]),
    ~s([7, 7, 7, 7]),
    ~s([7, 7, 7]),
    ~s([]),
    ~s([3]),
    ~s([[[]]]),
    ~s([[]]),
    ~s([1, [2, [3, [4, [5, 6, 7]]]], 8, 9]),
    ~s([1, [2, [3, [4, [5, 6, 0]]]], 8, 9])
  ]

  test "find_the_answer_p1" do
    output =
      @input
      |> parse_input()
      |> chunk_by_two()
      |> validate_pairs()

    assert output ==
             [true, true, false, true, false, true, false, false]

    assert sum_valid_indices(output) == 13
  end

  test "find_the_answer_p2" do
    output =
      @input
      |> parse_input()
      |> add_dividers()
      |> sort_packets()

    assert output
           |> multiply_divider_indices() == 140
  end
end
