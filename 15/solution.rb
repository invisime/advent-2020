#! /usr/bin/env ruby

require 'pry'

def play_game input, final_turn, verbose=false
	log = input.clone.unshift nil
	puts log.join "\n\t" if verbose

	last_occurrence = log[0..-2].map.with_index{|n,i| [n,i]}.to_h
	until log.count > final_turn do

		last_spoken = log[-1]
		last_turn = log.count - 1

		if last_occurrence.include?(last_spoken)
			speak = last_turn - last_occurrence[last_spoken]
		else
			speak = 0
		end

		last_occurrence[last_spoken] = last_turn

		puts [log.count, speak, ].join ":\t" if verbose

		log << speak
	end

	log
end


example_inputs = [
	[0, 3, 6],
	[1, 3, 2],
	[2, 1, 3],
	[1, 2, 3],
	[2, 3, 1],
	[3, 2, 1],
	[3, 1, 2]
]

input = [9, 3, 1, 0, 8, 4]

# Part 1

n = 2020
log = play_game input, n
puts log[-1]

# Part 2
n = 30000000
log = play_game input, n
puts log[n]
