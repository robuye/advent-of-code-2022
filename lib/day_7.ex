defmodule AOC.Day7 do
  @input_path "data/day_7.txt"

  import Stream, only: [map: 2, filter: 2]
  import Enum, only: [reduce: 3]

  def find_the_answer_p1() do
    stream_from_file()
    |> convert_input_to_data()
    |> filter_directories()
    |> filter_size_at_most(100_000)
    |> sum_sizes()
  end

  def convert_input_to_data(inputs) do
    {_pwd, data} =
      inputs
      |> reduce({["/"], %{}}, fn line, acc ->
        case line do
          "$ cd .." -> move_up(acc)
          "$ cd " <> cd_dir -> change_dir(acc, cd_dir)
          "$ ls" -> acc
          "dir " <> dir_name -> add_dir_entry(acc, dir_name)
          size_n_file -> add_file_entry(acc, size_n_file)
        end
      end)

    data
  end

  def filter_directories(data) do
    data
    |> Enum.flat_map(&filter_directory/1)
  end

  def filter_size_at_most(data, max_size) do
    data
    |> filter(fn {_name, size} -> size <= max_size end)
  end

  def sum_sizes(list) do
    list
    |> map(fn {_dir, size} -> size end)
    |> Enum.sum()
  end

  ### helpers
  def filter_directory({k, v}) when is_map(v) do
    elem = [{k, v["_size"]}]

    children =
      Enum.flat_map(v, fn {ck, cv} ->
        filter_directory({ck, cv})
      end)

    elem ++ children
  end

  def filter_directory(_), do: []

  def add_file_entry({pwd, acc}, file_data) do
    [size, file] = String.split(file_data)
    size = String.to_integer(size)

    contents =
      (get_in(acc, pwd) || %{})
      |> Map.put_new(file, size)

    acc =
      acc
      |> put_in(pwd, contents)
      |> recalculate_sizes_for_parents(pwd, size)

    {
      pwd,
      acc
    }
  end

  def add_dir_entry({pwd, acc}, dir) do
    # full_dir = Enum.join(pwd, "/")
    contents =
      (get_in(acc, pwd) || %{})
      |> Map.put_new(dir, %{})

    {
      pwd,
      put_in(acc, pwd, contents)
    }
  end

  def list_entries({pwd, acc}) do
    {pwd, acc}
  end

  def move_up({pwd, acc}) do
    {
      Enum.drop(pwd, -1),
      acc
    }
  end

  def change_dir({_pwd, acc}, "/") do
    {
      ["/"],
      acc
    }
  end

  def change_dir({pwd, acc}, dir) do
    new_pwd = pwd ++ [dir]

    {
      new_pwd,
      acc
    }
  end

  def recalculate_sizes_for_parents(acc, paths, size) do
    {_idx, acc} =
      reduce(paths, {1, acc}, fn _fragment, {idx, acc} ->
        update_path_segment = Enum.take(paths, idx)

        {_, contents} =
          get_in(acc, update_path_segment)
          |> Map.put_new("_size", 0)
          |> Map.get_and_update("_size", &{&1, &1 + size})

        {
          idx + 1,
          put_in(acc, update_path_segment, contents)
        }
      end)

    acc
  end

  def stream_from_file() do
    File.stream!(@input_path)
    |> map(&String.trim/1)
  end
end
