#! /usr/bin/env ruby

require 'pry'

# input_file = "example.txt"
input_file = "input.txt"

# Part 1
ready_time, bus_ids = File.readlines(input_file)

ready_time = ready_time.to_i
bus_ids = bus_ids.split(',').select{|id| id != 'x'}.map(&:to_i)

def next_departure ready_time, bus_id
	ready_time + bus_id - ( ready_time % bus_id )
end

def earliest_departure ready_time, bus_ids
	ids_by_departure = bus_ids.to_h{|id| [next_departure(ready_time, id), id]}
	earliest = ids_by_departure.keys.min
	[ids_by_departure[earliest], earliest]
end

bus_id, departure = earliest_departure ready_time, bus_ids
wait_time = departure - ready_time

puts bus_id * wait_time

binding.pry


# Part 2
