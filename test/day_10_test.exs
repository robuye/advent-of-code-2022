defmodule AOC.Day10.Test do
  use ExUnit.Case

  import AOC.Day10

  @test_input_path "data/day_10_tests.txt"

  test "find_the_answer_p1" do
    input =
      @test_input_path
      |> stream_from_file()
      |> parse_input()

    output =
      input
      |> run_instructions()

    assert Map.get(output.signal_strength_readings, 20) == 420
    assert Map.get(output.signal_strength_readings, 60) == 1140
    assert Map.get(output.signal_strength_readings, 100) == 1800
    assert Map.get(output.signal_strength_readings, 140) == 2940
    assert Map.get(output.signal_strength_readings, 180) == 2880
    assert Map.get(output.signal_strength_readings, 220) == 3960

    assert sum_up_strength_readings(output) == 13140
  end

  test "find_the_anwer_p2" do
    input =
      @test_input_path
      |> stream_from_file()
      |> parse_input()

    output =
      input
      |> run_instructions()
      |> get_crt_screen()

    assert Enum.at(output, 0) ==
             "##..##..##..##..##..##..##..##..##..##.."

    assert Enum.at(output, 1) ==
             "###...###...###...###...###...###...###."

    assert Enum.at(output, 2) ==
             "####....####....####....####....####...."

    assert Enum.at(output, 3) ==
             "#####.....#####.....#####.....#####....."

    assert Enum.at(output, 4) ==
             "######......######......######......####"

    assert Enum.at(output, 5) ==
             "#######.......#######.......#######....."
  end
end
