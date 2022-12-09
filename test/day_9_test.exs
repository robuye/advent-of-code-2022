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
      |> IO.inspect(label: "output")

    assert calculate_tail_visited_locations(output) == 13
  end
end
