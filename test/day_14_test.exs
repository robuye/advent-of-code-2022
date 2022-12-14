defmodule AOC.Day14.Test do
  use ExUnit.Case

  import AOC.Day14

  @input [
           "498,4 -> 498,6 -> 496,6",
           "503,4 -> 502,4 -> 502,9 -> 494,9"
         ]
         |> parse_input()

  test "find_the_answer_p1" do
    assert expand_coordinates(@input)
           |> Enum.at(0) ==
             [{496, 6}, {497, 6}, {498, 6}, {498, 5}, {498, 4}]

    output =
      @input
      |> expand_coordinates()
      |> to_map()
      |> drop_sand({500, 0})

    assert output == 24
  end

  test "find_the_answer_p2" do
    output =
      @input
      |> add_floor_layer()
      |> expand_coordinates()
      |> to_map()
      |> drop_sand({500, 0})

    assert output == 93
  end
end
