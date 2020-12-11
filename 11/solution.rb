#! /usr/bin/env ruby

require 'pry'

EMPTY = 'L'
OCCUPIED = '#'

# input_file = "example.txt"
input_file = "input.txt"

initial_layout = File.readlines(input_file).map(&:strip).map(&:chars)


def neighbor_coordinates row, column
	[[row - 1, column - 1], [row - 1, column], [row - 1, column + 1],
	 [row,     column - 1],										 [row,     column + 1],
	 [row + 1, column - 1], [row + 1, column], [row + 1, column + 1]]
end

def adjacent_occupied_seats layout, row, column
	height = layout.count
	width = layout.sample.count
	occupied_neighbors = neighbor_coordinates(row, column).select do |coordinate|
		r, c = coordinate
		inbounds = 0 <= r && r < height && 0 <= c && c < width
		inbounds && layout[r][c] == OCCUPIED
	end
	occupied_neighbors.count
end

def next_tick layout
	layout.map.with_index do |row_layout, row|
		row_layout.map.with_index do |seat, column|
			next_seat seat, adjacent_occupied_seats(layout, row, column)
		end
	end
end

def next_seat seat, occupied_neighbors
		if seat == EMPTY && occupied_neighbors == 0
			OCCUPIED
		elsif seat == OCCUPIED && occupied_neighbors >= 4
			EMPTY
		else
			seat
		end
end

def visual_from layout
	layout.map(&:join).join "\n"
end

# Part 1
timelapse = [initial_layout]

loop do
	next_layout = next_tick timelapse[-1]
	break if timelapse.map{|t| visual_from t}.include?(visual_from next_layout)
	timelapse << next_layout
end

puts timelapse[-1].flatten.count {|layout| layout.include? OCCUPIED}

# Part 2

binding.pry
