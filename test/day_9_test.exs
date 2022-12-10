defmodule AOC.Day9.Test do
  use ExUnit.Case

  import AOC.Day9

  test "find_the_answer_p1" do
    input =
      parse_input([
        "R 4",
        "U 4",
        "L 3",
        "D 1",
        "R 4",
        "D 1",
        "L 5",
        "R 2"
      ])

    output =
      input
      |> play_the_game()

    assert calculate_tail_visited_locations(output, 1) == 13
  end

  test "find_the_answer_p2" do
    input =
      parse_input([
        "R 5",
        "U 8",
        "L 8",
        "D 3",
        "R 17",
        "D 10",
        "L 25",
        "U 20"
      ])

    output =
      input
      |> play_the_game(9)

    assert calculate_tail_visited_locations(output, 9) == 36
  end
end
