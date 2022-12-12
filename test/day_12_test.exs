defmodule AOC.Day12.Test do
  use ExUnit.Case

  import AOC.Day12

  @input [
           "Sabqponm",
           "abcryxxl",
           "accszExk",
           "acctuvwj",
           "abdefghi"
         ]
         |> parse_input()

  test "find_the_answer_p1" do
    output =
      @input
      |> play_the_game()

    assert output.step == 31
  end
end
