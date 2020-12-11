#! /usr/bin/env ruby

require 'pry'

EMPTY = 'L'
OCCUPIED = '#'
FLOOR = '.'

# input_file = "example.txt"
input_file = "input.txt"

initial_layout = File.readlines(input_file).map(&:strip).map(&:chars)

def visual_from layout
	layout.map(&:join).join "\n"
end

$height = initial_layout.count
$width = initial_layout.sample.count
def inbounds r, c
	0 <= r && r < $height && 0 <= c && c < $width
end

def next_tick layout, seat_update, neighbor_noticer
	layout.map.with_index do |row_layout, row|
		row_layout.map.with_index do |seat, column|
			seat_update.call(seat, neighbor_noticer.call(layout, row, column))
		end
	end
end

def run_until_stasis layout, seat_update, neighbor_noticer
	timelapse = [layout]
	loop do
		next_layout = next_tick timelapse[-1,], Proc.new(&method(seat_update)), Proc.new(&method(neighbor_noticer))
		break if timelapse.map{|t| visual_from t}.include?(visual_from next_layout)
		timelapse << next_layout
	end
	timelapse
end

def count_occupied_seats layout
	layout.flatten.count {|layout| layout.include? OCCUPIED}
end

# Part 1

def next_seat seat, occupied_neighbors, threshold=4
		if seat == EMPTY && occupied_neighbors == 0
			OCCUPIED
		elsif seat == OCCUPIED && occupied_neighbors >= threshold
			EMPTY
		else
			seat
		end
end

def neighbor_coordinates row, column
	[[row - 1, column - 1], [row - 1, column], [row - 1, column + 1],
	 [row,     column - 1],										 [row,     column + 1],
	 [row + 1, column - 1], [row + 1, column], [row + 1, column + 1]]
end

def adjacent_occupied_seats layout, row, column
	occupied_neighbors = neighbor_coordinates(row, column).select do |coordinate|
		r, c = coordinate
		inbounds(r, c) && layout[r][c] == OCCUPIED
	end
	occupied_neighbors.count
end

part_1_update = :next_seat
part_1_neighbor = :adjacent_occupied_seats

timelapse = run_until_stasis initial_layout, part_1_update, part_1_neighbor
puts count_occupied_seats timelapse[-1]

# Part 2

def next_seat_2 seat, occupied_neighbors
	next_seat seat, occupied_neighbors, 5
end

def visible_from layout, row, column, direction
	next_row, next_column = neighbor_coordinates(row, column)[direction]
	return 0 unless inbounds(next_row, next_column)
	case layout[next_row][next_column]
	when FLOOR
		visible_from layout, next_row, next_column, direction
	when EMPTY
		0
	when OCCUPIED
	 1
	end
end

def line_of_sight_occupied_seats layout, row, column
	8.times.map{|direction| visible_from layout, row, column, direction}.sum
end

part_2_update = :next_seat_2
part_2_neighbor = :line_of_sight_occupied_seats
timelapse = run_until_stasis initial_layout, part_2_update, part_2_neighbor
puts count_occupied_seats timelapse[-1]
