require './tile_orientation'

class Puzzle

	SEA_MONSTER =
["                  # ",
 "#    ##    ##    ###",
 " #  #  #  #  #  #   "]

	ROTATED_SEA_MONSTERS = SEA_MONSTER[0].length.times.map{|r_c| SEA_MONSTER.size.times.map {|c_r| SEA_MONSTER[c_r][r_c] }.join }.to_a

	SEA_MONSTERS = [
		SEA_MONSTER,
		SEA_MONSTER.reverse,
		SEA_MONSTER.map(&:reverse),
		SEA_MONSTER.map(&:reverse).reverse,
		ROTATED_SEA_MONSTERS,
		ROTATED_SEA_MONSTERS.reverse,
		ROTATED_SEA_MONSTERS.map(&:reverse),
		ROTATED_SEA_MONSTERS.map(&:reverse).reverse,
	]

	def initialize tiles
		@tiles = tiles
		s = Math.sqrt tiles.count
		raise "non-square number of tiles" unless (@size = s.to_i) == s
		@tile_layout = @size.times.map { [Tile.blank] * @size }
	end

	def placed_tiles
		@tile_layout.flatten.reject {|tile| Tile.blank}
	end

	def northwest_corner
		return @northwest_corner unless @northwest_corner.nil?
		@northwest_corner = @tile_layout[0][0] = @tiles.select(&:corner?).first
	end

	def solve!
		define_axes!

		@size.times do |r|
			tile = @tile_layout[r][0]

			unless r == @size - 1
				south_neighbor = tile.possible_south_neighbors
				binding.pry unless south_neighbor.count == 1
				south_neighbor = south_neighbor.first

				south_neighbor.orient! :north, tile.south_edge.reverse
				@tile_layout[r + 1][0] = south_neighbor.place!
			end

			solve_row! r
		end

		binding.pry
	end

	# This method makes some assumptions about how the puzzle input is generated.
	# Most assumptions were manually validated against actual input.
	def define_axes!
		south_neighbor, east_neighbor = northwest_corner.all_possible_neighbors

		east_edge = northwest_corner.matching_edge east_neighbor
		northwest_corner.orient! :east, east_edge
		east_neighbor.orient! :west, east_edge.reverse
		@tile_layout[0][1] = east_neighbor

		south_neighbor.orient! :north, northwest_corner.south_edge.reverse
		@tile_layout[1][0] = south_neighbor
	end

	# In addition to the assumptions mentioned elsewhere, this method assumes the westmost
	# tile in the given row is already placed and oriented correctly.
	def solve_row! r
		row = @tile_layout[r]
		(0..@size-2).each do |column|
			tile = row[column]
			binding.pry if tile.blank?

			# assume that there is only one possible match for the next tile
			east_neighbor = tile.possible_east_neighbors
			binding.pry unless east_neighbor.count == 1
			east_neighbor = east_neighbor.first

			east_neighbor.orient! :west, tile.east_edge.reverse
			row[column + 1] = east_neighbor.place!
		end
	end

	def id_visualization
		@tile_layout.map do |row|
			row.map do |tile|
				"%04d" % tile.id
			end.join ' '
		end.join "\n"
	end

	def tile_visualization
		@tile_layout.map do |row_tiles|
			Tile.size.times.map do |tile_r|
				row_tiles.map { |tile| tile.oriented_grid[tile_r] }.join '  '
			end.join "\n"
		end.join "\n\n"
	end

	def borderless_tile_visualization show_gaps=true
		horizontal_gap = show_gaps ? ' ' : ''
		vertical_gap = show_gaps ? "\n\n" : "\n"

		@tile_layout.map do |row_tiles|
			Tile.size.times.to_a[1..-2].map do |tile_r|
				row_tiles.map { |tile| tile.oriented_grid[tile_r][1..-2] }.join horizontal_gap
			end.join "\n"
		end.join vertical_gap
	end
end
