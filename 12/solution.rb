#! /usr/bin/env ruby

require 'pry'

NORTH 	= 'N'
SOUTH 	= 'S'
EAST 		= 'E'
WEST 		= 'W'
LEFT 		= 'L'
RIGHT 	= 'R'
FORWARD = 'F'

class Action
	attr_accessor :direction, :distance, :to_s

	# right turns are positive incremements, left turns negative
	FACINGS = [NORTH, EAST, SOUTH, WEST]

	def initialize line
		@to_s = line
		@direction, @distance = line[0], line[1..-1].to_i
		raise "Invalid turn #{line}" if invalid_turn?
	end

	def turn?
		[LEFT, RIGHT].include?(direction)
	end

	def invalid_turn?
		turn? && (distance % 90 != 0)
	end


	def new_facing old_facing
		old_index = FACINGS.index old_facing
		new_index = (old_index + rotations) % 4
		return FACINGS[new_index]
	end

	def rotations
		return 0 unless turn?
		(4 + (direction == RIGHT ? 1 : -1) * distance / 90) % 4
	end
end

class Navigation
	attr_accessor :part
	attr_reader :actions, :facing, :longitude, :latitude, :waypoint_longitude, :waypoint_latitude

	def initialize input_file, part=1
		@part = part
		@actions = File.readlines(input_file).map{|line| Action.new line}
		reset
	end

	def reset
		@longitude, @latitude = 0, 0
		@facing = EAST
		@waypoint_longitude, @waypoint_latitude = 10, 1
		position
	end

	def simulate
		reset
		puts position if part == 2
		@actions.each do |action|
			puts action
			perform action
			puts position if part == 2
		end
	end

	def perform action
		part == 1 ? perform_original(action) : perform_new(action)
	end

	def perform_original action
		case action.direction
		when NORTH
			@latitude += action.distance
		when SOUTH
			@latitude -= action.distance
		when EAST
			@longitude += action.distance
		when WEST
			@longitude -= action.distance
		when LEFT, RIGHT
			@facing = action.new_facing facing
		when FORWARD
			perform_original Action.new "#@facing#{action.distance}"
		else
			raise "Unknown action type #{action.direction}."
		end
	end

	def perform_new action
		case action.direction
		when NORTH
			@waypoint_latitude += action.distance
		when SOUTH
			@waypoint_latitude -= action.distance
		when EAST
			@waypoint_longitude += action.distance
		when WEST
			@waypoint_longitude -= action.distance
		when LEFT, RIGHT
			rotate_waypoint action.rotations
		when FORWARD
			@latitude += waypoint_latitude * action.distance
			@longitude += waypoint_longitude * action.distance
		else
			raise "Unknown action type #{action.direction}."
		end
	end

	def rotate_waypoint rotations
		case rotations
		when 1
			temp = -@waypoint_longitude
			@waypoint_longitude = @waypoint_latitude
			@waypoint_latitude = temp
		when 2
			@waypoint_longitude *= -1
			@waypoint_latitude *= -1
		when 3
			temp = -@waypoint_latitude
			@waypoint_latitude = @waypoint_longitude
			@waypoint_longitude = temp
		end
	end

	def longitude_description value
		(value >= 0 ? "east" : "west") + " " + value.abs.to_s
	end

	def latitude_description value
		(value >= 0 ? "north" : "south") + " " + value.abs.to_s
	end

	def position
		location = "#{longitude_description longitude}, #{latitude_description latitude}"
		location += "\n\twaypoint: #{longitude_description @waypoint_longitude}, #{latitude_description @waypoint_latitude}" if @part == 2
		location
	end

	def manhattan_distance_from_start
		latitude.abs + longitude.abs
	end
end

input_file = "example.txt"
input_file = "input.txt"

# Part 1
navigation = Navigation.new input_file
navigation.simulate
puts navigation.manhattan_distance_from_start
puts

# Part 2
navigation.part = 2
navigation.simulate
puts navigation.manhattan_distance_from_start

binding.pry
