defmodule QwertyDvorak do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def to_dvorak(word, map) do
    word
    |> String.downcase
    |> String.split("")
    |> Enum.map(fn(c) -> map[c] end)
    |> Enum.join("")
  end

  def print_str(s) do
    IO.inspect(s)
  end

  def n_processes(words, map, index) do
    me = self
    words
    |>  Stream.map(fn(elem) ->
          spawn(fn ->
            send(me, {self, elem, to_dvorak(elem, map)})
          end)
        end)

    |>  Stream.map(fn(pid) ->
          receive do
            {pid, orig, dvorak} ->
              {orig, dvorak}
          end
        end)
    |>  Enum.filter(fn({orig, dvorak}) ->
          case index[dvorak] do
            :y -> true
            _ -> false
          end
        end)

    |> IO.inspect
  end

  def make_index(file) do
    {:ok, words} = File.read(file)
    words = String.split(words, "\n")
    for word <- words, into: %{}, do: {word, :y}
  end

  def sixteen_processes(map) do
    {:ok, file} = File.open("/usr/share/dict/words")
    index = make_index("/usr/share/dict/words")
    IO.binstream(file, :line)
    |> Stream.filter(fn(word) -> !String.contains?(word, ["e", "E", "q", "Q", "w", "W", "z", "Z"]) end)
    |>  Stream.map(fn(word) ->
          Task.async(fn -> to_dvorak(word, map) end)
        end)

    |> Stream.map(fn(t) -> Task.await(t) end)
    |> Enum.filter
    |> IO.inspect
  end

  def pmap(list, func) do
    me = self

    list
    |>  Enum.map(fn(elem) ->
          spawn(fn ->
            send(me, {self, func.(elem)})
          end)
        end)

    |>  Enum.map(fn(pid) ->
          receive do
            {pid, result} ->
              result
          end
        end)
  end

  def do_main() do
    main(nil)
  end

  def get_words() do
    {:ok, file} = File.read("/usr/share/dict/words")
    words = String.split(file, "\n")
    |> Enum.filter(fn(word) -> !String.contains?(word, ["e", "E", "q", "Q", "w", "W", "z", "Z"]) end)

    index = for word <- words, into: %{}, do: {word, :y}
    {words, index}
  end

  def main(args) do
      {words, index} = get_words()

      q_to_d = %{
        "a" => "a",
        "b" => "x",
        "c" => "j",
        "d" => "e",
        "f" => "u",
        "g" => "i",
        "h" => "d",
        "i" => "c",
        "j" => "h",
        "k" => "t",
        "l" => "n",
        "m" => "m",
        "n" => "b",
        "o" => "r",
        "p" => "l",
        "r" => "p",
        "s" => "o",
        "t" => "y",
        "u" => "g",
        "v" => "k",
        "x" => "q",
        "y" => "f"
      }

      n_processes(words, q_to_d, index)
      #sixteen_processes(q_to_d)
  end
end
