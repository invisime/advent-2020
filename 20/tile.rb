class Tile

	attr_reader :raw_grid, :id

	def initialize chunk
		label, *@raw_grid = chunk.split "\n"
		@id = label.split(/[\:\s]/)[1].to_i
		@edges_to_direction = {
			raw_grid[0] => :north, # left to right
			raw_grid.map {|line| line[-1]}.join => :east, # top to bottom
			raw_grid[-1].reverse => :south, # right to left
			raw_grid.map {|line| line[0]}.join.reverse => :west, # bottom to top
		}
		@size = raw_grid[0].length
		Tile[@id] = self
	end

	def to_s
		["Tile #@id:", *@raw_grid].join "\n"
	end

	def edges
		@edges_to_direction.keys
	end

	def flipped_edges
		edges.map(&:reverse).reverse
	end

	def possible_edges
		edges | flipped_edges
	end

	def matching_edges other_tile
		edges & other_tile.possible_edges
	end

	def all_possible_neighbors
		@all_possible_neighbors ||= Tile.all.select do |other_tile|
			other_tile != self &&
			matching_edges(other_tile).any?
		end
	end

	def visual
		visual_slice 0, 0, @size - 1, @size - 1
	end

	alias_method :inspect, :visual

	def visual_slice top, left, right, bottom
		raw_grid[top..bottom].map {|row| row[left..right]}
	end

	@@by_id = {}

	def self.[] id
		@@by_id[id]
	end

	def self.[]= id, tile
		@@by_id[id] = tile
	end

	def self.all
		@@by_id.values
	end
end
