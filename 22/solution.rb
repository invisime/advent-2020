#! /usr/bin/env ruby

require 'pry'

# input_file = "example.txt"
input_file = "input.txt"

player_decks = File.read(input_file).split("\n\n").map{|chunk| chunk.split("\n")[1..-1].map(&:to_i) }

until player_decks.any?(&:empty?)
	play_1 = player_decks[0].shift
	play_2 = player_decks[1].shift
	if play_1 > play_2
		player_decks[0].push play_1, play_2
	else
		player_decks[1].push play_2, play_1
	end
end

winning_deck = player_decks.select(&:any?)[0]
puts winning_deck.map.with_index {|card, position| card * (winning_deck.count - position) }.sum

binding.pry
