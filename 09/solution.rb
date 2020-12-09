#! /usr/bin/env ruby

require 'pry'

# sequence = (1..25).to_a.shuffle.reject{|n| n == 20}.unshift(20)

input_file, preamble =
	#	"example.txt", 5
 "input.txt", 25

sequence = File.readlines(input_file).map(&:to_i)

# Part 1
def valid? subsequence, sum
	subsequence.each.with_index do |n, i|
		return true if subsequence[(i+1)..-1].include?(sum - n)
	end
	false
end

invalid_number = nil
preamble.upto(sequence.count - 1) do |i|
	n = sequence[i]
	next if valid? sequence[(i-preamble)..i], n
	invalid_number = n
	break
end

puts invalid_number.nil? ? "no invalid number found" : invalid_number

# Part 2
weak_range = nil
sequence.each.with_index do |n, i|
	j = i
	contiguous_range = []
	while contiguous_range.sum < invalid_number do
		j += 1
		contiguous_range = sequence[i..j]
	end
	next unless contiguous_range.sum == invalid_number
	weak_range = contiguous_range
	break
end

puts invalid_number.nil? ? "no weak range found" : (weak_range.min + weak_range.max)
