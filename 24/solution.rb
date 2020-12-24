#! /usr/bin/env ruby

require 'pry'

class HexTile

	DIRECTION_REGEXP = /(ne|e|se|sw|w|nw)/

	attr_reader :location

	def initialize x, y
		@location = [x, y]
	end

	def self.from_instructions line
		instructions = line.scan(DIRECTION_REGEXP).map(&:first)
		raise "invalid parse detected" unless instructions.join == line
		location = [0, 0]
		instructions.each { |d| location = HexTile.next_to *location, d }
		HexTile.new *location
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
		when :se
			[x, y - 1]
		when :nw
			[x, y + 1]
		end
	end
end

# input_file = 'example.txt'
input_file = 'input.txt'

lines = File.readlines(input_file, chomp: true)

# Part 1

tiles = lines.map{|line| HexTile.from_instructions line }
flips_per_tile = tiles.group_by(&:location).to_h{|location, tiles| [location, tiles.count]}
puts flips_per_tile.values.select(&:odd?).count

# Part 2

binding.pry
