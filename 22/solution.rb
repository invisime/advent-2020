#! /usr/bin/env ruby

require 'set'
require 'pry'

def play_game player_1, player_2, recurse

	player_1 = player_1.clone
	player_2 = player_2.clone
	player_decks = [player_1, player_2]

	$game ||= 0
	game = $game += 1
	previous_game_states = Set[]
	round = 0

	puts "=== Game #{game} ===", nil if $verbose

	until player_decks.any?(&:empty?)
		round += 1

		if $verbose
			puts("-- Round #{round} (Game #{game}) --",
				"Player 1's deck: #{player_1.join ', '}",
				"Player 2's deck: #{player_2.join ', '}"
			)
		end

		this_state = player_1.join(',') + '|' + player_2.join(',')
		return player_decks if recurse && previous_game_states.include?(this_state)
		previous_game_states.add this_state

		play_1 = player_1.shift
		play_2 = player_2.shift

		puts "Player 1 plays: #{play_1}", "Player 2 plays: #{play_2}" if $verbose

		if recurse && play_1 <= player_1.count && play_2 <= player_2.count
			puts "Playing a sub-game to determine the winner...", nil if $verbose
			results = play_game player_1.take(play_1), player_2.take(play_2), recurse
			player_1_wins = results.first.any?
			puts "...anyway, back to game #{game}!" if $verbose
		else
			player_1_wins = play_1 > play_2
		end

		puts "Player #{player_1_wins ? 1 : 2} wins round #{round} of game #{game}!", nil if $verbose

		if player_1_wins
			player_1.push play_1, play_2
		else
			player_2.push play_2, play_1
		end
	end

	puts "The winner of game #{game} is player #{player_decks.first.any? ? 1 : 2}!", nil if $verbose
	player_decks
end

def winning_score player_decks
	winning_deck = player_decks.select(&:any?).first
	winning_deck.map.with_index {|card, position| card * (winning_deck.count - position) }.sum
end


# input_file = "example.txt"
input_file = "input.txt"

player_decks = File.read(input_file).split("\n\n").map{|chunk| chunk.split("\n")[1..-1].map(&:to_i) }

# Part 1
puts winning_score(play_game(*player_decks, false))

# Part 2
$game = 0
puts winning_score(play_game(*player_decks, true))
