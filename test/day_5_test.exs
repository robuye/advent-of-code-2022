defmodule AOC.Day5.Test do
  use ExUnit.Case

  @crates [
    ~w|N Z|,
    ~w|D C M|,
    ~w|P|
  ]

  @moves [
    ~s|move 1 from 2 to 1|,
    ~s|move 3 from 1 to 3|,
    ~s|move 2 from 2 to 1|,
    ~s|move 1 from 1 to 2|
  ]

  test "play_the_game/2" do
    output =
      @moves
      |> AOC.Day5.translate_moves()
      |> AOC.Day5.play_the_game(@crates)
      |> Enum.to_list()

    assert output == [
             ~w|C|,
             ~w|M|,
             ~w|Z N D P|
           ]
  end

  test "translate_moves/1" do
    output =
      [
        "move 3 from 1 to 8",
        "move 10 from 2 to 1"
      ]
      |> AOC.Day5.translate_moves()
      |> Enum.to_list()

    assert output == [
             %{count: 3, from: 1, to: 8},
             %{count: 10, from: 2, to: 1}
           ]
  end
end
