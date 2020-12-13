#! /usr/bin/env ruby

require 'pry'

# input_file = "example.txt"
input_file = "input.txt"

# Part 1
ready_time, bus_ids = File.readlines(input_file)

ready_time = ready_time.to_i
bus_ids = bus_ids.split(',').map(&:to_i)

def next_departure ready_time, bus_id
	ready_time + bus_id - ( ready_time % bus_id )
end

def earliest_departure ready_time, bus_ids
	ids_by_departure = bus_ids.to_h{|id| [next_departure(ready_time, id), id]}
	earliest = ids_by_departure.keys.min
	[ids_by_departure[earliest], earliest]
end

bus_id, departure = earliest_departure ready_time, bus_ids.reject(&:zero?)
wait_time = departure - ready_time

puts bus_id * wait_time

# Part 2

def wins_contest? bus_ids, t
	bus_ids.each.with_index do |id, i|
# 		binding.pry
		next if id.zero?
		return false unless (t % id) == (id - i) % id
	end
	true
end

# brute force bad
# modulo = bus_ids.max
# r = bus_ids.index modulo
# test_t = modulo - r
# test_t += modulo until wins_contest? bus_ids, test_t

# Chinese remainder theorem good
t = 0
increment = bus_ids[0]
bus_ids.each.with_index do |id, index|
	next if id.zero? || index.zero?
	t += increment until (t % id) == (id - index) % id
	increment *= id
end

puts t
