defmodule AOC.Day7.Test do
  use ExUnit.Case

  import AOC.Day7

  test "find_the_answer_p1" do
    input = [
      "$ cd /",
      "$ ls",
      "dir a",
      "14848514 b.txt",
      "8504156 c.dat",
      "dir d",
      "$ cd a",
      "$ ls",
      "dir e",
      "29116 f",
      "2557 g",
      "62596 h.lst",
      "$ cd e",
      "$ ls",
      "584 i",
      "$ cd ..",
      "$ cd ..",
      "$ cd d",
      "$ ls",
      "4060174 j",
      "8033020 d.log",
      "5626152 d.ext",
      "7214296 k"
    ]

    output =
      input
      |> convert_input_to_data()
      |> filter_directories()
      |> filter_size_at_most(100_000)
      |> Enum.into(%{})

    assert output["a"] == 94853
    assert output["e"] == 584

    # / is too big
    assert output["/"] == nil

    assert sum_sizes(output) == 95437
  end
end
