#! /usr/bin/env ruby

require 'pry'

class Seat

		attr_reader :row, :column, :seat_id

    def initialize boarding_pass
			@raw = boarding_pass
			@row = @raw[0..6].gsub(/F/, '0').gsub(/B/, '1').to_i(2)
			@column = @raw[7..9].gsub(/L/, '0').gsub(/R/, '1').to_i(2)
			@seat_id = @row * 8 + @column
    end

		def to_s
			"#@raw: row #@row, column #@column, seat ID #@seat_id"
		end
end

input_file = "input.txt"

seats = File.readlines(input_file).map {|line| Seat.new line}

# Part 1
puts seats.map(&:seat_id).max

# Part 2
all_seat_ids = seats.map(&:seat_id).sort
expected_id = all_seat_ids[0]
all_seat_ids.each do |this_id|
	if expected_id == this_id
		expected_id = this_id + 1
		next
	else
		puts expected_id
		break
	end
end

