#! /usr/bin/env ruby

require 'pry'

# input_file = "example1.txt"
# input_file = "example2.txt"
input_file = "input.txt"

adapters = File.readlines(input_file).map(&:to_i).sort

# Part 1
joltage_differences = {1 => 0, 2 => 0, 3 => 1}
previous_joltage = 0
adapters.each do |adapter|
	difference = adapter - previous_joltage
	raise "invalid adapter" unless joltage_differences.keys.include? difference
	joltage_differences[difference] += 1
	previous_joltage = adapter
end

puts(joltage_differences[1] * joltage_differences[3])

binding.pry

# Part 2
