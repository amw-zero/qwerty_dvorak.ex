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
		words = File.stream!("/usr/share/dict/words") |> Stream.run
	    index = for word <- words, into: %{}, do: {word, :y}

	    # Use patterns for this
		filtered_words = Stream.filter(words, fn line ->
			!String.contains?(line, ["e", "E", "q", "Q", "w", "W", "z", "Z"])
		end)
	   	|> Enum.map(&(String.strip(&1)))

	    {filtered_words, index}
	end

	def run do
#		profile do
		{words, index} = QwertyDvorak.get_words()
		Enum.each(words, fn word ->
			converted = replace(word)
			if String.length(converted) > 0 do
			 	case index[converted] do
			 		:y -> IO.puts "#{word} -> #{converted}"
				 	_ -> 
			 	end
			end
		end)
#		end
	end

	def main(args) do
		run
	end
end
