defmodule AOC.Day11.Test do
  use ExUnit.Case

  import AOC.Day11

  @test_input_path "data/day_11_test.txt"

  test "find_the_answer_p1" do
    input =
      @test_input_path
      |> stream_from_file()
      |> parse_input()

    output =
      input
      |> play_the_game(20)

    assert output[0].starting_items == [10, 12, 14, 26, 34]
    assert output[1].starting_items == [245, 93, 53, 199, 115]
    assert output[2].starting_items == []
    assert output[3].starting_items == []

    assert output[0].num_items_inspected == 101
    assert output[1].num_items_inspected == 95
    assert output[2].num_items_inspected == 7
    assert output[3].num_items_inspected == 105
  end
end
