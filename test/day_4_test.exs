defmodule AOC.Day4.Test do
  use ExUnit.Case

  test "find_the_answer_p1/0" do
    input = [
      "2-4,6-8",
      "2-3,4-5",
      "5-7,7-9",
      "2-8,3-7",
      "6-6,4-6",
      "2-6,4-8"
    ]

    [p1, p2, p3, p4, p5, p6] =
      input
      |> AOC.Day4.to_maps()
      |> AOC.Day4.split_pairs()
      |> AOC.Day4.expand_ranges()
      |> AOC.Day4.tag_contained_groups()
      |> Enum.to_list()

    assert p1.elf_a == 2..4
    assert p1.elf_b == 6..8

    assert p2.elf_a == 2..3
    assert p2.elf_b == 4..5

    assert p3.elf_a == 5..7
    assert p3.elf_b == 7..9

    assert p1.overlaps_completely == false
    assert p2.overlaps_completely == false
    assert p3.overlaps_completely == false
    assert p4.overlaps_completely == true
    assert p5.overlaps_completely == true
    assert p6.overlaps_completely == false
  end
end
