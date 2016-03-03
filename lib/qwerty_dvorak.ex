defmodule QwertyDvorak do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def to_dvorak(word, map) do
    word
    |> String.split("")
    |> Enum.map(fn(c) -> map[c] end)
    |> Enum.join("")
  end

  def print_str(s) do
    IO.inspect(s)
  end

  def n_processes(words, map) do
    me = self
    words
    |>  Enum.map(fn(elem) ->
          spawn(fn ->
            send(me, {self, to_dvorak(elem, map)})
          end)
        end)

    |>  Enum.map(fn(pid) ->
          receive do
            {pid, result} ->
              result
          end
        end)
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

  def main(args) do
      {:ok, file} = File.read('/usr/share/dict/words')
      words = String.split(file, "\n")

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

      n_processes(words, q_to_d)
  end
end
