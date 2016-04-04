defmodule QwertyDvorak do
  q_to_d = %{
    "a" => "a",
    "A" => "A",
    "b" => "x",
    "B" => "X",
    "c" => "j",
    "C" => "J",
    "d" => "e",
    "D" => "E",
    "f" => "u",
    "F" => "U",
    "g" => "i",
    "G" => "I",
    "h" => "d",
    "H" => "D",
    "i" => "c",
    "I" => "C",
    "j" => "h",
    "J" => "H",
    "k" => "t",
    "K" => "T",
    "l" => "n",
    "L" => "N",
    "m" => "m",
    "M" => "M",
    "n" => "b",
    "N" => "B",
    "o" => "r",
    "O" => "R",
    "p" => "l",
    "P" => "L",
    "r" => "p",
    "R" => "P",
    "s" => "o",
    "S" => "O",
    "t" => "y",
    "T" => "Y",
    "u" => "g",
    "U" => "G",
    "v" => "k",
    "V" => "K",
    "x" => "q",
    "X" => "Q",
    "y" => "f",
    "Y" => "F"
  }

  def convert(<<>>), do: <<>>
  for {q, d} <- q_to_d do
    def convert(unquote(q) <> rest), do: unquote(d) <> convert(rest)
  end

  def open_and_split_file do
    String.split(File.read!("/usr/share/dict/words"), "\n")
  end

  def create_index(words) do
      for word <- words, into: %{}, do: {word, :y}  
  end

  def convert_and_check(words, index) do
    Enum.each(words, fn word ->
      unless String.contains?(word, ["e", "E", "q", "Q", "w", "W", "z", "Z"]) do
        converted = convert(word)
        case index[converted] do
          :y -> IO.puts "#{word} -> #{converted}"
          _ -> 
        end
      end
    end)
  end

  def main(args) do
    words = open_and_split_file
    index = create_index(words)
    convert_and_check(words, index)   
  end
end
