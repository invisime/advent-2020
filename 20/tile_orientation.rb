require './tile'

class Tile
	def oriented_grid
		return @oriented_grid unless @oriented_grid.nil?

		@rotations ||= 0
		@flipped ||= false

		oriented = @raw_grid.map(&:clone)

		(@rotations ||= 0).times do
			oriented.map(&:clone).each.with_index do |row, r|
				row.chars.each.with_index { |pixel, c| oriented[c][-1-r] = pixel }
			end
		end

		oriented.map!(&:reverse) if flipped?

		@oriented_grid = oriented
	end

	def placed?
		!!@placed
	end

	def place!
		@placed = true
		self
	end

	def ensure_unplaced
		raise "Attempted to rotate placed tile #@id." if placed?
	end

	def rotate!
		ensure_unplaced
		@rotations = ((@rotations || 0) + 1) % 4
		@oriented_grid = nil
	end

	def flipped?
		!!@flipped
	end

	def flip!
		ensure_unplaced
		@flipped = !flipped?
		@oriented_grid = nil
	end

	# returns whether reorientation was necessary
	def orient! direction, edge
		return false if edge_to_the(direction) == edge
		ensure_unplaced
		2.times do
			DIRECTIONS.count.times do
				rotate!
				return true if edge_to_the(direction) == edge
			end
			flip!
		end
		raise "Could not orient piece so that edge matched."
	end

	DIRECTIONS = [:north, :east, :south, :west]

	def edge_to_the direction
		edges(oriented_grid)[DIRECTIONS.index direction]
	end

	def possible_neighbors_to direction
		raise "Blank tile has no neighbors." if self.blank?
		edge = edge_to_the direction
		all_possible_neighbors.select do |neighbor|
			(neighbor.matching_edges(self) & [edge, edge.reverse]).any?
		end
	end

	DIRECTIONS.each do |d|
		define_method("#{d}_edge", -> { edge_to_the d })
		define_method("possible_#{d}_neighbors", -> { possible_neighbors_to d })
	end

	def oriented_inspect
		[@label, *oriented_grid].join "\n"
	end

	alias_method :inspect, :oriented_inspect
end
