#! /usr/bin/env ruby

require 'pry'
require './ticket'
require './field'

# input_file = "example1.txt"
# input_file = "example2.txt"
input_file = "input.txt"

raw_fields, raw_my_ticket, raw_other_tickets = File.read(input_file).split("\n\n").map{|chunk| chunk.split("\n")}

Ticket.fields = raw_fields.map{|line| Field.new line}
my_ticket = Ticket.new raw_my_ticket[-1]
other_tickets = raw_other_tickets[1..-1].map {|line| Ticket.new line}

# Part 1
puts other_tickets.map(&:invalid_values).flatten.sum

# Part 2
valid_other_tickets = other_tickets.select(&:possibly_valid?)

field_location_pairs = Ticket.fields.map do |field|
	possible_indices = valid_other_tickets.sample.values.count.times.to_a
	valid_other_tickets.each do |ticket|
		possible_indices.each do |i|
			possible_indices.delete i unless field.valid? ticket.values[i]
		end
	end
	[field.name, possible_indices]
end

known_indices = []
field_indicies = field_location_pairs.sort!{|a,b| a[1].count <=> b[1].count}.map do |name, indicies|
	possibilities = indicies - known_indices
	raise "ambiguous fields" unless possibilities.count == 1
	known_indices << possibilities[0]
	[name, possibilities[0]]
end.to_h

departure_fields = field_indicies.select{|key| key.include? "departure"}
puts departure_fields.values.map{|i| my_ticket.values[i]}.reduce(&:*)
