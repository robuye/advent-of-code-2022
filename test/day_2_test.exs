defmodule AOC.Day2.Test do
  use ExUnit.Case

  test "translate_codes/1" do
    input = [
      ["A", "Z"],
      ["B", "Y"],
      ["C", "X"]
    ]

    output =
      input
      |> AOC.Day2.translate_codes()
      |> Enum.to_list()

    assert output == [
      [:rock, :scissors],
      [:paper, :paper],
      [:scissors, :rock]
    ]
  end

  test "play_the_game/1" do
    # [<opponent>, <suggestion>]
    input = [
      [:rock, :rock],
      [:scissors, :paper],
      [:paper, :scissors]
    ]

    output =
      input
      |> AOC.Day2.play_the_game()
      |> Enum.to_list()

    # [<opponent>, <suggestion>, <score>]
    assert output == [
             [:rock, :rock, 4],
             [:scissors, :paper, 2],
             [:paper, :scissors, 9]
           ]
  end

  test "is_win?/2" do
    assert AOC.Day2.is_win?(:rock, :rock) == false
    assert AOC.Day2.is_win?(:rock, :paper) == false
    assert AOC.Day2.is_win?(:rock, :scissors) == true

    assert AOC.Day2.is_win?(:paper, :rock) == true
    assert AOC.Day2.is_win?(:paper, :paper) == false
    assert AOC.Day2.is_win?(:paper, :scissors) == false

    assert AOC.Day2.is_win?(:scissors, :rock) == false
    assert AOC.Day2.is_win?(:scissors, :paper) == true
    assert AOC.Day2.is_win?(:scissors, :scissors) == false
  end

  test "is_draw?/2" do
    assert AOC.Day2.is_draw?(:rock, :rock) == true
    assert AOC.Day2.is_draw?(:rock, :paper) == false
    assert AOC.Day2.is_draw?(:rock, :scissors) == false

    assert AOC.Day2.is_draw?(:paper, :rock) == false
    assert AOC.Day2.is_draw?(:paper, :paper) == true
    assert AOC.Day2.is_draw?(:paper, :scissors) == false

    assert AOC.Day2.is_draw?(:scissors, :rock) == false
    assert AOC.Day2.is_draw?(:scissors, :paper) == false
    assert AOC.Day2.is_draw?(:scissors, :scissors) == true
  end

  test "calculate_score/2" do
    # Points for item played:
    #  :rock -> 1
    #  :paper -> 2
    #  :scissors -> 3
    # Points for game result:
    #  :won -> 6
    #  :draw -> 3
    #  :lost -> 0

    assert AOC.Day2.calculate_score(:rock, :rock) == 1 + 3
    assert AOC.Day2.calculate_score(:rock, :paper) == 1 + 0
    assert AOC.Day2.calculate_score(:rock, :scissors) == 1 + 6

    assert AOC.Day2.calculate_score(:paper, :rock) == 2 + 6
    assert AOC.Day2.calculate_score(:paper, :paper) == 2 + 3
    assert AOC.Day2.calculate_score(:paper, :scissors) == 2 + 0

    assert AOC.Day2.calculate_score(:scissors, :rock) == 3 + 0
    assert AOC.Day2.calculate_score(:scissors, :paper) == 3 + 6
    assert AOC.Day2.calculate_score(:scissors, :scissors) == 3 + 3
  end
end
