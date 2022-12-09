defmodule AOC.Day8 do
  @input_path "data/day_8.txt"

  import Stream, only: [map: 2]

  def find_the_answer_p1(input \\ nil) do
    (input || stream_from_file())
    |> parse_input()
    |> add_visibility_info()
    |> Enum.flat_map(& &1)
    |> Enum.filter(fn {_tree, is_visible} -> is_visible end)
    |> Enum.count()
  end

  def find_the_answer_p2() do
    stream_from_file()
    |> parse_input()
    |> add_scenic_scores()
    |> Enum.flat_map(& &1)
    |> Enum.max()
  end

  def add_visibility_info(forest) do
    forest
    |> Enum.with_index()
    |> Enum.map(fn {row, pos_y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {tree, pos_x} ->
        is_visible =
          is_visible(tree, trees_from_top(forest, {pos_x, pos_y})) ||
            is_visible(tree, trees_from_bottom(forest, {pos_x, pos_y})) ||
            is_visible(tree, trees_from_left(forest, {pos_x, pos_y})) ||
            is_visible(tree, trees_from_right(forest, {pos_x, pos_y}))

        {tree, is_visible}
      end)
    end)
  end

  def add_scenic_scores(forest) do
    forest
    |> Enum.with_index()
    |> Enum.map(fn {row, pos_y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {tree, pos_x} ->
        [
          trees_from_top(forest, {pos_x, pos_y}),
          trees_from_bottom(forest, {pos_x, pos_y}),
          trees_from_left(forest, {pos_x, pos_y}),
          trees_from_right(forest, {pos_x, pos_y})
        ]
        |> Enum.map(fn line -> calculate_line_score(tree, line) end)
        |> Enum.reduce(1, fn score, total -> total * score end)
      end)
    end)
  end

  def calculate_line_score(tree, line_of_trees) do
    line_of_trees
    |> Enum.reduce_while(0, fn next_tree, score ->
      if next_tree >= tree do
        {:halt, score + 1}
      else
        {:cont, score + 1}
      end
    end)
  end

  def is_visible(tree, surrounding_trees) do
    surrounding_trees
    |> Enum.all?(fn next_tree -> next_tree < tree end)
  end

  def trees_from_top(_forest, {_x, 0}), do: []

  def trees_from_top(forest, {x, tree_y}) do
    forest_edge = 0

    Range.new(tree_y - 1, forest_edge)
    |> Enum.map(fn y -> get_tree(forest, {x, y}) end)
  end

  def trees_from_bottom(forest, {x, tree_y}) do
    forest_edge = Enum.count(forest) - 1

    if tree_y == forest_edge do
      []
    else
      Range.new(tree_y + 1, forest_edge)
      |> Enum.map(fn y -> get_tree(forest, {x, y}) end)
    end
  end

  def trees_from_left(_forest, {0, _y}), do: []

  def trees_from_left(forest, {tree_x, y}) do
    forest_edge = 0

    Range.new(tree_x - 1, forest_edge)
    |> Enum.map(fn x -> get_tree(forest, {x, y}) end)
  end

  def trees_from_right(forest, {tree_x, y}) do
    forest_edge =
      forest
      |> Enum.at(y)
      |> Enum.count()
      |> then(fn count -> count - 1 end)

    if tree_x == forest_edge do
      []
    else
      Range.new(tree_x + 1, forest_edge)
      |> Enum.map(fn x -> get_tree(forest, {x, y}) end)
    end
  end

  def get_tree(forest, {x, y}) do
    forest
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def parse_input(lines) do
    lines
    |> map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
    # using stream down the line makes the program very slow
    |> Enum.to_list()
  end

  def stream_from_file() do
    File.stream!(@input_path)
    |> map(&String.trim/1)
  end
end
