defmodule QwertyDvorak do
  import ExProf.Macro

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
    #profile do
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
    #end
  end
end
