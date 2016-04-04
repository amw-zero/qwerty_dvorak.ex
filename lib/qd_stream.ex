defmodule QD do
	import ExProf.Macro

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

	# Qwerty -> Dvorak conversion

		

	def get_words() do
	    {:ok, file} = File.read("/usr/share/dict/words")
	    words = String.split(file, "\n")
	    index = for word <- words, into: %{}, do: {word, :y}

	    # Use patterns for this
		filtered_words = Stream.filter(words, fn line ->
			!String.contains?(line, ["e", "E", "q", "Q", "w", "W", "z", "Z"])
		end)

	    {filtered_words, index}
	end

	def run do
		{words, index} = QD.get_words()
		Enum.each(words, fn word ->
			converted = convert(word)
			if String.length(converted) > 0 do
			 	case index[converted] do
			 		:y -> IO.puts "#{word} -> #{converted}"
				 	_ -> 
			 	end
			end
		end)
	end

	def convert_word(word) do
		String.codepoints(word)		
		|> Enum.map(&convert_case/1)
	end

	def convert_case(letter) do
		case letter do
			"a" -> "a"
			"A" -> "A"
	        "b" -> "x"
	        "B" -> "X"
	        "c" -> "j"
	        "C" -> "J"
	        "d" -> "e"
	        "D" -> "E"
	        "f" -> "u"
	        "F" -> "U"
	        "g" -> "i"
	        "G" -> "I"
	        "h" -> "d"
	        "H" -> "D"
	        "i" -> "c"
	        "I" -> "C"
	        "j" -> "h"
	        "J" -> "H"
	        "k" -> "t"
	        "K" -> "T"
	        "l" -> "n"
	        "L" -> "N"
	        "m" -> "m"
	        "M" -> "M"
	        "n" -> "b"
	        "N" -> "B"
	        "o" -> "r"
	        "O" -> "R"
	        "p" -> "l"
	        "P" -> "L"
	        "r" -> "p"
	        "R" -> "P"
	        "s" -> "o"
	        "S" -> "O"
	        "t" -> "y"
	        "T" -> "Y"
	        "u" -> "g"
	        "U" -> "G"
	        "v" -> "k"
	        "V" -> "K"
	        "x" -> "q"
	        "X" -> "Q"
	        "y" -> "f"
	        "Y" -> "F"
	        "" -> ""
		end
	end

	def open_file do
		File.read!("/usr/share/dict/words")
	end

	def open_and_split_file do
		String.split(File.read!("/usr/share/dict/words"), "\n")
	end

	def convert_words(words) do
		Enum.each(words, fn word ->
			unless String.contains?(word, ["e", "E", "q", "Q", "w", "W", "z", "Z"]) do
				convert(word)
			end
		end)
	end

	def convert_words_with_case(words) do
		Enum.each(words, fn word ->
			unless String.contains?(word, ["e", "E", "q", "Q", "w", "W", "z", "Z"]) do
				convert_word(word)
			end
		end)
	end

	def convert_and_check(words, index) do
		Enum.each(words, fn word ->
			unless String.contains?(word, ["e", "E", "q", "Q", "w", "W", "z", "Z"]) do
				converted = convert(word)
				case index[converted] do
			 		:y -> {}#IO.puts "#{word} -> #{converted}"
				 	_ -> 
			 	end
			end
		end)
	end

	def convert_and_check_with_case(words, index) do
		Enum.each(words, fn word ->
			unless String.contains?(word, ["e", "E", "q", "Q", "w", "W", "z", "Z"]) do
				converted = convert_word(word)
				case index[converted] do
			 		:y -> {}#IO.puts "#{word} -> #{converted}"
				 	_ -> 
			 	end
			end
		end)
	end

	def profile_parts do
		{time, _} = :timer.tc QD, :open_file, []
		IO.puts "Time to open file: #{time}"

		{time, _} = :timer.tc QD, :open_and_split_file, []
		IO.puts "Time to open and split file: #{time}"

		{time, _} = :timer.tc QD, :convert_case, ["a"]
		IO.puts "Time to convert one letter: #{time}"

		words = open_and_split_file
		{time, _} = :timer.tc QD, :convert_words, [words]
		IO.puts "Time to convert words: #{time}"

		{time, _} = :timer.tc QD, :convert_words_with_case, [words]
		IO.puts "Time to convert words via case: #{time}"		

		index = create_index(words)

		{time, _} = :timer.tc QD, :convert_and_check, [words, index]
		IO.puts "Time to convert and check words: #{time}"

		{time, _} = :timer.tc QD, :run_all, []
		IO.puts "Time to do the whole thing: #{time}"
	end

	def create_index(words) do
	    for word <- words, into: %{}, do: {word, :y}	
	end

	def profile_all do
		profile do
			run_all
		end
	end

	def run_all do
		words = open_and_split_file
		index = create_index(words)
		convert_and_check(words, index)
	end

	def main(args) do
		#run_all

		profile_parts
	end
end
