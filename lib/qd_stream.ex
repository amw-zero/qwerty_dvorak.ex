defmodule QD do
	import ExProf.Macro

	# Qwerty -> Dvorak conversion
	def replace(<<>>), do: <<>>
	def replace("a" <> rest), do: "a" <> replace(rest)
	def replace("A" <> rest), do: "A" <> replace(rest)
	def replace("b" <> rest), do: "x" <> replace(rest)
	def replace("B" <> rest), do: "X" <> replace(rest)	
	def replace("c" <> rest), do: "j" <> replace(rest)
	def replace("C" <> rest), do: "J" <> replace(rest)	
	def replace("d" <> rest), do: "e" <> replace(rest)	
	def replace("D" <> rest), do: "E" <> replace(rest)		
	def replace("f" <> rest), do: "u" <> replace(rest)	
	def replace("F" <> rest), do: "U" <> replace(rest)		
	def replace("g" <> rest), do: "i" <> replace(rest)	
	def replace("G" <> rest), do: "I" <> replace(rest)		
	def replace("h" <> rest), do: "d" <> replace(rest)
	def replace("H" <> rest), do: "D" <> replace(rest)	
	def replace("i" <> rest), do: "c" <> replace(rest)
	def replace("I" <> rest), do: "C" <> replace(rest)	
	def replace("j" <> rest), do: "h" <> replace(rest)	
	def replace("J" <> rest), do: "H" <> replace(rest)		
	def replace("k" <> rest), do: "t" <> replace(rest)
	def replace("K" <> rest), do: "T" <> replace(rest)	
	def replace("l" <> rest), do: "n" <> replace(rest)
	def replace("L" <> rest), do: "N" <> replace(rest)	
	def replace("m" <> rest), do: "m" <> replace(rest)		
	def replace("M" <> rest), do: "M" <> replace(rest)			
	def replace("n" <> rest), do: "b" <> replace(rest)	
	def replace("N" <> rest), do: "B" <> replace(rest)		
	def replace("o" <> rest), do: "r" <> replace(rest)
	def replace("O" <> rest), do: "R" <> replace(rest)	
	def replace("p" <> rest), do: "l" <> replace(rest)
	def replace("P" <> rest), do: "L" <> replace(rest)	
	def replace("r" <> rest), do: "p" <> replace(rest)
	def replace("R" <> rest), do: "P" <> replace(rest)
	def replace("s" <> rest), do: "o" <> replace(rest)		
	def replace("S" <> rest), do: "O" <> replace(rest)	
	def replace("t" <> rest), do: "y" <> replace(rest)				
	def replace("T" <> rest), do: "Y" <> replace(rest)					
	def replace("u" <> rest), do: "g" <> replace(rest)				
	def replace("U" <> rest), do: "G" <> replace(rest)					
	def replace("v" <> rest), do: "k" <> replace(rest)		
	def replace("V" <> rest), do: "K" <> replace(rest)			
	def replace("x" <> rest), do: "q" <> replace(rest)		
	def replace("X" <> rest), do: "Q" <> replace(rest)			
	def replace("y" <> rest), do: "f" <> replace(rest)
	def replace("Y" <> rest), do: "F" <> replace(rest)	

	def q_to_d do
		%{
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
	end

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
			converted = replace(word)
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
				replace(word)
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
				converted = replace(word)
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
