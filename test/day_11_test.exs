defmodule AOC.Day11.Test do
  use ExUnit.Case

  import AOC.Day11

  @input "data/day_11_test.txt"
         |> stream_from_file()
         |> parse_input()

  test "find_the_answer_p1" do
    output =
      @input
      |> play_the_game(rounds: 20, div_by_three: true)

    assert output[0].starting_items == [10, 12, 14, 26, 34]
    assert output[1].starting_items == [245, 93, 53, 199, 115]
    assert output[2].starting_items == []
    assert output[3].starting_items == []

    assert output[0].num_items_inspected == 101
    assert output[1].num_items_inspected == 95
    assert output[2].num_items_inspected == 7
    assert output[3].num_items_inspected == 105
  end

  test "find_the_answer_p2" do
    output =
      @input
      |> play_the_game(rounds: 10000, div_by_three: false)

    assert output[0].num_items_inspected == 52166
    assert output[1].num_items_inspected == 47830
    assert output[2].num_items_inspected == 1938
    assert output[3].num_items_inspected == 52013
  end
end
