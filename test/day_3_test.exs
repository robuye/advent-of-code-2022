defmodule AOC.Day3.Test do
  use ExUnit.Case

  test "split_into_compartments/1" do
    input = [
      "aaaabbbb",
      "cccddd",
      "666666gggggg"
    ]

    output =
      input
      |> AOC.Day3.split_into_compartments()
      |> Enum.to_list()

    assert output == [
             {"aaaa", "bbbb"},
             {"ccc", "ddd"},
             {"666666", "gggggg"}
           ]
  end

  test "add_common_elements/1" do
    input = [
      {"abcDEF", "fghIJK"},
      {"abcDEF", "abcIJK"},
      {"abcabc", "abcIJa"}
    ]

    output =
      input
      |> AOC.Day3.add_common_elements()
      |> Enum.to_list()

    assert output == [
             {"abcDEF", "fghIJK", ""},
             {"abcDEF", "abcIJK", "abc"},
             {"abcabc", "abcIJa", "abc"}
           ]
  end

  test "sum_priorities_of_common_elements/1" do
    input = [
      {nil, nil, "a"},
      {nil, nil, "zz"},
      {nil, nil, "AAA"},
      {nil, nil, "ZZZZ"}
    ]

    output =
      input
      |> AOC.Day3.sum_priorities_of_common_elements()

    assert output == 1 * 1 + 2 * 26 + 3 * 27 + 4 * 52
  end

  test "get_priority/1" do
    assert AOC.Day3.get_priority("") == 0
    assert AOC.Day3.get_priority("a") == 1
    assert AOC.Day3.get_priority("b") == 2
    assert AOC.Day3.get_priority("z") == 26
    assert AOC.Day3.get_priority("A") == 27
    assert AOC.Day3.get_priority("Z") == 52
  end
end
