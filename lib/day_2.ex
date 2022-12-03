defmodule AOC.Day2 do
  @input_path "data/day_2.txt"

  import Stream, only: [map: 2]

  @codes %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,
    "X" => :rock,
    "Y" => :paper,
    "Z" => :scissors
  }

  def find_the_answer_p1() do
    stream_from_file()
    |> translate_codes()
    |> play_the_game()
    |> sum_up_scores()
  end

  def stream_from_file() do
    File.stream!(@input_path)
    |> map(&String.trim/1)
    |> map(&String.split/1)
  end

  def translate_codes(moves) do
    moves
    |> map(fn [opponent, you] ->
      [
        @codes[opponent],
        @codes[you]
      ]
    end)
  end

  def play_the_game(moves) do
    moves
    |> map(fn [opponent, suggestion] ->
      [
        opponent,
        suggestion,
        calculate_score(suggestion, opponent)
      ]
    end)
  end

  def sum_up_scores(moves) do
    moves
    |> map(fn [_, _, score] -> score end)
    |> Enum.sum()
  end

  def calculate_score(you, opponent) do
    winning_score =
      cond do
        is_win?(you, opponent) -> 6
        is_draw?(you, opponent) -> 3
        true -> 0
      end

    item_score =
      case you do
        :rock -> 1
        :paper -> 2
        :scissors -> 3
      end

    winning_score + item_score
  end

  def is_win?(:rock, :scissors), do: true
  def is_win?(:paper, :rock), do: true
  def is_win?(:scissors, :paper), do: true
  def is_win?(_, _), do: false

  def is_draw?(l, r) when l == r, do: true
  def is_draw?(_, _), do: false
end
