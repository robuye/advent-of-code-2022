defmodule AOC.Day4 do
  @input_path "data/day_4.txt"

  import Stream, only: [map: 2]

  def find_the_answer_p1() do
    stream_from_file()
    |> to_maps()
    |> split_pairs()
    |> expand_ranges()
    |> tag_contained_groups()
    |> count_groups_overlaping_completely()
  end

  def stream_from_file() do
    File.stream!(@input_path)
    |> map(&String.trim/1)
  end

  def to_maps(input) do
    input
    |> map(fn s -> %{source: s} end)
  end

  def split_pairs(groups) do
    groups
    |> map(fn group ->
      [left, right] = String.split(group.source, ",")

      group
      |> Map.put(:elf_a, left)
      |> Map.put(:elf_b, right)
    end)
  end

  def expand_ranges(groups) do
    groups
    |> map(fn group ->
      group
      |> Map.put(:elf_a, expand_range(group.elf_a))
      |> Map.put(:elf_b, expand_range(group.elf_b))
    end)
  end

  # str_range is "6-11"
  def expand_range(str_range) do
    [range_start, range_end] = String.split(str_range, "-")

    Range.new(
      String.to_integer(range_start),
      String.to_integer(range_end)
    )
  end

  def tag_contained_groups(groups) do
    groups
    |> map(fn group ->
      should_tag =
        contains_all?(group.elf_a, group.elf_b) ||
          contains_all?(group.elf_b, group.elf_a)

      group
      |> Map.put(:overlaps_completely, should_tag)
    end)
  end

  def contains_all?(left, right) do
    left.first <= right.first && left.last >= right.last
  end

  def count_groups_overlaping_completely(groups) do
    groups
    |> Enum.count(& &1.overlaps_completely)
  end
end
