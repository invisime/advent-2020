#! /usr/bin/env ruby

require 'pry'

class HexTile

	DIRECTIONS = %w(e w ne sw nw se).map(&:to_sym)
	DIRECTION_REGEXP = Regexp.new "(#{DIRECTIONS.join '|'})"

	def self.from_instructions line
		instructions = line.scan(DIRECTION_REGEXP).map(&:first)
		location = [0, 0]
		instructions.each { |d| location = HexTile.next_to *location, d }
		location
	end

	def self.next_to x, y, direction
		case direction.to_sym
		when :e
			[x + 1, y]
		when :w
			[x - 1, y]
		when :ne
			[x + 1, y + 1]
		when :sw
			[x - 1, y - 1]
		when :nw
			[x, y + 1]
		when :se
			[x, y - 1]
		end
	end

	def self.neighbors_of x, y
		DIRECTIONS.map{|direction| HexTile.next_to x, y, direction	}
	end
end

class TiledLobby
	def initialize locations_of_black_tiles
		@tiles = locations_of_black_tiles.to_h {|location| [location, true]}
	end

	def retile_for_next_day!
		locations_to_handle = @tiles.keys | @tiles.keys.map{|l| HexTile.neighbors_of *l}.reduce(&:+)
		new_tiles = {}
		locations_to_handle.each do |location|
			touching_tiles = HexTile.neighbors_of(*location).select{|l| @tiles.include? l}.count
			if @tiles.include? location
				new_tiles[location] = true if [1, 2].include? touching_tiles
			else
				new_tiles[location] = true if touching_tiles == 2
			end
		end
		@tiles = new_tiles
	end

	def count_black_tiles
		@tiles.count{|location, flipped| flipped}
	end
end

# input_file = 'example.txt'
input_file = 'input.txt'

lines = File.readlines(input_file, chomp: true)

# Part 1

locations = lines.map{|line| HexTile.from_instructions line }
flips_per_tile = locations.group_by{|_|_}.to_h{|location, instances| [location, instances.count]}
black_tile_locations = flips_per_tile.select{|location, count| count.odd? }.keys
lobby_floor = TiledLobby.new black_tile_locations
puts lobby_floor.count_black_tiles

# Part 2

100.times { lobby_floor.retile_for_next_day! }
puts lobby_floor.count_black_tiles
