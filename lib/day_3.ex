defmodule AOC.Day3 do
  @input_path "data/day_3.txt"

  @priorities Enum.concat(
                Enum.map(?a..?z, fn ch -> {to_string([ch]), ch - 96} end),
                Enum.map(?A..?Z, fn ch -> {to_string([ch]), ch - 38} end)
              )
              |> Enum.into(%{})
              |> Map.put("", 0)

  import Stream,
    only: [
      map: 2,
      chunk_every: 2
    ]

  def find_the_answer_p1() do
    stream_from_file()
    |> split_into_compartments()
    |> add_common_elements()
    |> sum_priorities_of_common_elements()
  end

  def find_the_answer_p2() do
    stream_from_file()
    |> chunk_every(3)
    |> add_badges_and_prios()
    |> sum_groups_prios()
  end

  def sum_groups_prios(groups) do
    groups
    |> map(& &1.priority)
    |> Enum.sum()
  end

  def add_badges_and_prios(groups) do
    groups
    |> map(fn [one, two, three] ->
      badge =
        MapSet.intersection(
          String.to_charlist(one) |> MapSet.new(),
          String.to_charlist(two) |> MapSet.new()
        )
        |> MapSet.intersection(String.to_charlist(three) |> MapSet.new())
        |> Enum.to_list()
        |> to_string()

      %{
        members: [one, two, three],
        badge: badge,
        priority: get_priority(badge)
      }
    end)
  end

  def sum_priorities_of_common_elements(runsacks) do
    runsacks
    |> map(fn {_, _, common_els} ->
      common_els
      |> String.graphemes()
      |> Enum.map(&get_priority/1)
      |> Enum.sum()
    end)
    |> Enum.to_list()
    |> Enum.sum()
  end

  def split_into_compartments(runsacks) do
    runsacks
    |> map(fn line ->
      String.split_at(
        line,
        div(String.length(line), 2)
      )
    end)
  end

  def add_common_elements(runsacks) do
    runsacks
    |> map(fn {left, right} ->
      both =
        MapSet.intersection(
          MapSet.new(String.to_charlist(left)),
          MapSet.new(String.to_charlist(right))
        )
        |> Enum.to_list()

      {left, right, to_string(both)}
    end)
  end

  def get_priority(ch), do: @priorities[ch]

  def stream_from_file() do
    File.stream!(@input_path)
    |> map(&String.trim/1)
  end
end
