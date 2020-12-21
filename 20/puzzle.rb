require './tile_orientation'

class Puzzle

SEA_MONSTER = %s(
                  #
#    ##    ##    ###
 #  #  #  #  #  #)[1..-1]

	def initialize tiles
		@tiles = tiles
		s = Math.sqrt tiles.count
		raise "non-square number of tiles" unless (@size = s.to_i) == s
		@tile_layout = @size.times.map { [nil] * @size }
		@blank_tile = @tiles.sample.size.times.map { ' ' * @size }.join "\n"
	end

	def placed_tiles
		@tile_layout.flatten.reject(&:nil?)
	end

	def solve
		northwest_corner = @tile_layout[0][0] = @tiles.first(&:corner?)
		east_neighbor, south_neighbor = northwest_corner.all_possible_neighbors

		# rotate corner so edge is east
		east_edge = northwest_corner.matching_edge east_neighbor
		northwest_corner.orient! :east, east_edge

		# rotate neighbors into position and place them
		# go row by row and pray?

		binding.pry

		@tile_layout.each do |row|
			row.each do |tile|
				next unless tile.nil?

			end
		end
	end

	def visualization
		@tile_layout.map do |row_tiles|
			row_tiles.map.with_index do |tile, r|
				binding.pry
			end.join
		end.join "\n"
	end
end
