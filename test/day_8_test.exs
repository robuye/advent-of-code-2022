defmodule AOC.Day8.Test do
  use ExUnit.Case

  import AOC.Day8

  test "find_the_answer_p1" do
    input = [
      "30373",
      "25512",
      "65332",
      "33549",
      "35390"
    ]

    assert find_the_answer_p1(input) == 21

    assert trees_from_top(
             parse_input(input),
             {3, 3}
           ) == [3, 1, 7]

    assert trees_from_top(
             parse_input(input),
             {3, 4}
           ) == [4, 3, 1, 7]

    assert trees_from_bottom(
             parse_input(input),
             {2, 3}
           ) == [3]

    assert trees_from_bottom(
             parse_input(input),
             {3, 3}
           ) == [9]

    assert trees_from_bottom(
             parse_input(input),
             {3, 4}
           ) == []

    assert trees_from_left(
             parse_input(input),
             {4, 0}
           ) == [7, 3, 0, 3]

    assert trees_from_left(
             parse_input(input),
             {3, 0}
           ) == [3, 0, 3]

    assert trees_from_right(
             parse_input(input),
             {1, 3}
           ) == [5, 4, 9]

    assert trees_from_right(
             parse_input(input),
             {1, 2}
           ) == [3, 3, 2]

    assert trees_from_right(
             parse_input(input),
             {4, 3}
           ) == []

    assert is_visible(
             7,
             [1, 2, 5, 6]
           ) == true

    assert is_visible(
             7,
             [1, 7, 5, 6]
           ) == false
  end

  test "find_the_answer_p2" do
    input =
      [
        "30373",
        "25512",
        "65332",
        "33549",
        "35390"
      ]
      |> parse_input()

    output =
      input
      |> add_scenic_scores()

    assert get_tree(output, {2, 1}) == 4
    assert get_tree(output, {2, 3}) == 8
  end
end
