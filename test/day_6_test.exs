defmodule AOC.Day6.Test do
  use ExUnit.Case

  import AOC.Day6

  test "find_the_answer_p1" do
    # How many characters need to be processed before the first
    # start-of-packet marker is detected?
    output_1 =
      "bvwbjplbgvbhsrlpgdmjqwftvncz"
      |> find_the_answer_p1()

    assert output_1 == 5

    output_2 =
      "nppdvjthqldpwncqszvftbrmjlhg"
      |> find_the_answer_p1()

    assert output_2 == 6

    output_3 =
      "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
      |> find_the_answer_p1()

    assert output_3 == 10

    output_4 =
      "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
      |> find_the_answer_p1()

    assert output_4 == 11
  end

  test "find_the_answer_p2" do
    # How many characters need to be processed before the first
    # start-of-message marker is detected?

    output_1 =
      "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
      |> find_the_answer_p2()

    assert output_1 == 19

    output_2 =
      "bvwbjplbgvbhsrlpgdmjqwftvncz"
      |> find_the_answer_p2()

    assert output_2 == 23

    output_3 =
      "nppdvjthqldpwncqszvftbrmjlhg"
      |> find_the_answer_p2()

    assert output_3 == 23

    output_4 =
      "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
      |> find_the_answer_p2()

    assert output_4 == 29

    output_5 =
      "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
      |> find_the_answer_p2()

    assert output_5 == 26
  end
end
