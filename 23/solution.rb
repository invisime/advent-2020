#! /usr/bin/env ruby

require 'pry'

def tick c
	cups = c.clone
	current_cup, *picked_up_cups = cups.shift 4

	destination_cup = current_cup
	destination_cup = (destination_cup + 7) % 9 + 1 until cups.include? destination_cup
	destination = cups.index(destination_cup) + 1

	cups.insert destination, *picked_up_cups
	cups.push current_cup

	cups
end

def cups_after_1 c
	cups = c.clone
	cups.rotate! until cups[0] == 1
	cups[1..-1].join
end


example_input = "389125467"
real_input = "538914762"
input = real_input

# Part 1

cups = input.chars.map(&:to_i)
100.times { cups = tick cups }
puts cups_after_1 cups

# Part 2


binding.pry
