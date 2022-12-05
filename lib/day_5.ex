defmodule AOC.Day5 do
  @input_path "data/day_5.txt"

  import Stream, only: [map: 2, filter: 2]

  @crates [
    ~w|N T B S Q H G R|,
    ~w|J Z P D F S H|,
    ~w|V H Z|,
    ~w|H G F J Z M|,
    ~w|R S M L D C Z T|,
    ~w|J Z H V W T M|,
    ~w|Z L P F T|,
    ~w|S W V Q|,
    ~w|C N D T M L H W|
  ]

  def find_the_answer_p1() do
    stream_from_file()
    |> translate_moves()
    |> play_the_game(@crates)
    |> read_top_items()
  end

  def find_the_answer_p2() do
    stream_from_file()
    |> translate_moves()
    |> play_the_game_v2(@crates)
    |> read_top_items()
  end

  def stream_from_file() do
    File.stream!(@input_path)
    |> map(&String.trim/1)
    |> filter(&String.starts_with?(&1, "m"))
  end

  def translate_moves(moves) do
    regex = ~r|^move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)|

    moves
    |> map(fn line ->
      Regex.named_captures(regex, line)
      |> Enum.into(%{}, fn {k, v} ->
        {String.to_atom(k), String.to_integer(v)}
      end)
    end)
  end

  # move: %{count: 2, from: 1, to: 2}
  def play_the_game(moves, crates) do
    moves
    |> Enum.reduce(crates, fn move, crates ->
      1..move.count
      |> Enum.reduce(crates, fn _i, crates ->
        # arrays are 0 indexed, moves are not
        from_stack = Enum.at(crates, move.from - 1)
        to_stack = Enum.at(crates, move.to - 1)

        # take item from the top and move to new stack
        {item, from_stack} = take_from_top(from_stack)
        to_stack = put_on_top(to_stack, item)

        # swap old stacks
        crates
        |> List.replace_at(move.from - 1, from_stack)
        |> List.replace_at(move.to - 1, to_stack)
      end)
    end)
  end

  def play_the_game_v2(moves, crates) do
    moves
    |> Enum.reduce(crates, fn move, crates ->
      from_stack = Enum.at(crates, move.from - 1)
      to_stack = Enum.at(crates, move.to - 1)

      {items_to_move, from_stack} = Enum.split(from_stack, move.count)
      to_stack = items_to_move ++ to_stack

      crates
      |> List.replace_at(move.from - 1, from_stack)
      |> List.replace_at(move.to - 1, to_stack)
    end)
  end

  def read_top_items(crates) do
    crates
    |> map(&List.first/1)
    |> Enum.join()
  end

  defp take_from_top(stack) do
    List.pop_at(stack, 0)
  end

  defp put_on_top(stack, item) do
    List.insert_at(stack, 0, item)
  end
end
