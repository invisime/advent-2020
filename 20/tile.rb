class Tile

	attr_reader :input, :id

	alias_method :inspect, :input

	def initialize chunk
		@input = chunk
		label, *@raw_grid = chunk.split "\n"
		@id = label.split(/[\:\s]/)[1].to_i
		@size = @raw_grid[0].length
		Tile[@id] = self
	end

	def edges grid=@raw_grid
		[
			grid[0],																# north, left to right
			grid.map {|line| line[-1]}.join,				# east, top to bottom
			grid[-1].reverse, 											# south, right to left
			grid.map {|line| line[0]}.join.reverse, # west, bottom to top
		]
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

	def matching_edge other_tile
		matches = matching_edges other_tile
		raise "Expected 1 matching edge. Found #{matches.count}." unless matches.count == 1
		matches.first
	end

	def all_possible_neighbors
		@all_possible_neighbors ||= Tile.all.select do |other_tile|
			other_tile != self &&
			matching_edges(other_tile).any?
		end
	end

	def corner?
		all_possible_neighbors.count == 2
	end

	def edge?
		all_possible_neighbors.count <= 3
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
