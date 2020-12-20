SEA_MONSTER = %s(
                  #
#    ##    ##    ###
 #  #  #  #  #  #   )[1..-1]

class Tile
	def oriented_grid
		return @oriented_grid unless @oriented_grid.nil?

		@rotations ||= 0
		@flipped ||= false

		oriented = @raw_grid.map(&:clone)

		@rotations.times do
			oriented.map(&:clone).each.with_index do |row, r|
				row.chars.each.with_index { |pixel, c| oriented[c][-1-r] = pixel }
			end
		end

		oriented.map!(&:reverse) if flipped?

		@oriented_grid = oriented
	end

	def flipped?
		!!@flipped
	end

	DIRECTIONS = [:north, :east, :south, :west]

	def edges_by_direction
		edges(oriented_grid).map.with_index{|edge, d| [DIRECTIONS[d], edge]}.to_h
	end

	DIRECTIONS.each { |d| define_method(direction, -> { edges_by_direction[direction] }) }

	def rotate!
		@rotations = (@rotations + 1) % 4
		@oriented_grid = nil
	end

	def flip!
		@flipped = !flipped?
		@oriented_grid = nil
	end

	def visualization
		oriented_grid.join "\n"
	end
end

class Puzzle
	def initialize tiles
		@tiles = tiles
		s = Math.sqrt tiles.count
		raise "non-square number of tiles" unless (@size = s.to_i) == s
		@tile_layout = @size.times.map { [nil] * @size }
	end

	def placed_tiles
		@tile_layout.flatten
	end

	def solve
		northwest_corner = @tile_layout[0][0] = @tiles.first(&:corner?)
		northwest_corner.all_possible_neighbors.each do |neighbor|
			edge = northwest_corner.matching_edge neighbor
			binding.pry
		end
		@tile_layout.each do |row|
			row.each do |tile|
				next unless tile.nil?

			end
		end
	end
end
