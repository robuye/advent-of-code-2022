defmodule AOC.Day11 do
  @input_path "data/day_11.txt"

  def find_the_answer_p1() do
    stream_from_file()
    |> parse_input()
    |> play_the_game(rounds: 20, div_by_three: true)
    |> get_the_busiest_monkeys(2)
    |> Enum.map(& &1.num_items_inspected)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def find_the_answer_p2() do
    stream_from_file()
    |> parse_input()
    |> play_the_game(rounds: 10000, div_by_three: false)
    |> get_the_busiest_monkeys(2)
    |> Enum.map(& &1.num_items_inspected)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def play_the_game(monkeys, opts \\ []) do
    rounds = Keyword.get(opts, :rounds, 20)

    div_by_three = Keyword.get(opts, :div_by_three, true)

    modulo_all =
      Map.values(monkeys)
      |> Enum.map(& &1.test_divisor)
      |> Enum.reduce(&(&1 * &2))

    1..rounds
    |> Enum.reduce(monkeys, fn _round, outer_acc ->
      Map.keys(monkeys)
      |> Enum.reduce(outer_acc, fn id, inner_acc ->
        inner_acc
        |> play_a_round(id, div_by_three, modulo_all)
      end)
    end)
  end

  def get_the_busiest_monkeys(all, n) do
    all
    |> Map.values()
    |> Enum.sort_by(& &1.num_items_inspected, :desc)
    |> Enum.take(n)
  end

  def play_a_round(all, id, div_by_three, modulo_all) do
    monkey = Map.fetch!(all, id)

    {on_success_items, on_failure_items} =
      monkey.starting_items
      |> Enum.reduce({[], []}, fn item, acc ->
        new_item =
          inspect_item(monkey.operation, item)
          |> then(&if div_by_three, do: div(&1, 3), else: &1)
          |> rem(modulo_all)

        {success_items, failure_items} = acc

        rem(new_item, monkey.test_divisor)
        |> case do
          0 -> {success_items ++ [new_item], failure_items}
          _ -> {success_items, failure_items ++ [new_item]}
        end
      end)

    success_m =
      Map.fetch!(all, monkey.on_success)
      |> Map.update(:starting_items, on_success_items, fn prev_items ->
        prev_items ++ on_success_items
      end)

    failure_m =
      Map.fetch!(all, monkey.on_failure)
      |> Map.update(:starting_items, on_failure_items, fn prev_items ->
        prev_items ++ on_failure_items
      end)

    new_monkey =
      monkey
      |> Map.put(:starting_items, [])
      |> Map.update(:num_items_inspected, -1, fn prev ->
        prev + Enum.count(monkey.starting_items)
      end)

    all
    |> Map.put(monkey.id, new_monkey)
    |> Map.put(monkey.on_success, success_m)
    |> Map.put(monkey.on_failure, failure_m)
  end

  def inspect_item(operation, level) do
    {mod, fun, args} = operation

    apply(mod, fun, [level | args])
  end

  def parse_input(lines) do
    lines
    |> Enum.to_list()
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(length(&1) == 1))
    |> Enum.map(fn sentences ->
      sentences
      |> Enum.reduce(%{}, fn line, monkey ->
        Map.merge(
          monkey,
          parse_sentence(line)
        )
      end)
    end)
    |> Enum.map(&{&1.id, &1})
    |> Enum.into(%{})
  end

  def parse_sentence("Monkey " <> rest) do
    {num, _colon} = String.next_grapheme(rest)

    %{
      name: "Monkey #{num}",
      id: to_int(num)
    }
  end

  def parse_sentence("Starting items: " <> items_str) do
    items_str
    |> String.split(", ")
    |> Enum.map(&to_int/1)
    |> then(&%{starting_items: &1, num_items_inspected: 0})
  end

  def parse_sentence("Operation: " <> op_string) do
    mfa =
      case op_string do
        "new = old * old" -> {Kernel, :**, [2]}
        "new = old * " <> x -> {Kernel, :*, [to_int(x)]}
        "new = old + " <> x -> {Kernel, :+, [to_int(x)]}
      end

    %{operation: mfa}
  end

  def parse_sentence("Test: divisible by " <> divisor_s) do
    %{test_divisor: to_int(divisor_s)}
  end

  def parse_sentence("If true: throw to monkey " <> monkey_s) do
    %{on_success: to_int(monkey_s)}
  end

  def parse_sentence("If false: throw to monkey " <> monkey_s) do
    %{on_failure: to_int(monkey_s)}
  end

  def stream_from_file(path \\ nil) do
    (path || @input_path)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  defp to_int(str) when is_binary(str), do: String.to_integer(str)
end
