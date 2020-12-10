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
	raise "invalid adapter difference: #{difference} at joltage #{adapter}" unless difference == 1 || difference == 3
	joltage_differences[difference] += 1
	previous_joltage = adapter
end

puts(joltage_differences[1] * joltage_differences[3])

# Part 2
paths_to_joltage = Hash.new { 0 }
paths_to_joltage[0] = 1
[0, *adapters].each do |adapter|
	1.upto(3) do |jump|
		desired_joltage = adapter + jump
		paths_to_joltage[desired_joltage] += paths_to_joltage[adapter] if adapters.include? desired_joltage
	end
end

puts paths_to_joltage[adapters.max]
