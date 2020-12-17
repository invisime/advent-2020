class Grid4D
	ACTIVE = '#'
	INACTIVE = '.'

	def initialize origin_layer
		@history = [{0 => {0 => {}}}]
		@min_z = 0
		@max_z = 0
		@min_w = 0
		@max_w = 0
		@min_y = 0
		@min_x = 0
		origin_layer.each.with_index do |row, y|
			cubes[0][0][y] = {}
			@max_y = y
			row.each.with_index do |status, x|
				cubes[0][0][y][x] = status
				@max_x = x
			end
		end
	end

	def cubes
		@history[cycles]
	end

	def cycles
		@history.count - 1
	end

	def active? w, x, y, z
		cubes.include?(w) &&
		cubes[w].include?(z) &&
		cubes[w][z].include?(y) &&
		cubes[w][z][y][x] == ACTIVE
	end

	def visualization
		@min_w.upto(@max_w).map do |w|
			@min_z.upto(@max_z).map do |z|
				"z=#{z}, w=#{w}\n" + @min_y.upto(@max_y).map do |y|
					@min_x.upto(@max_x).map do |x|
						cubes[w][z][y][x]
					end.join
				end.join("\n")
			end.join("\n\n")
		end.join("\n\n")
	end

	def tick
		new_cubes = {}

		min_w = @max_w
		min_x = @max_x
		min_y = @max_y
		min_z = @max_z

		max_w = @min_w
		max_x = @min_x
		max_y = @min_y
		max_z = @min_z

		(@min_w - 1).upto(@max_w + 1).each do |w|
			new_cubes[w] = {}
			(@min_z - 1).upto(@max_z + 1).each do |z|
				new_cubes[w][z] = {}
				(@min_y - 1).upto(@max_y + 1).each do |y|
					new_cubes[w][z][y] = {}
					(@min_x - 1).upto(@max_x + 1).each do |x|
						old_status = active? w, x, y, z
						new_cubes[w][z][y][x] = status = new_status w, x, y, z
						if status == ACTIVE
							min_w = [w, min_w].min
							max_w = [w, max_w].max
							min_x = [x, min_x].min
							max_x = [x, max_x].max
							min_y = [y, min_y].min
							max_y = [y, max_y].max
							min_z = [z, min_z].min
							max_z = [z, max_z].max
						end
					end
				end
			end
		end

		@history << new_cubes
		@min_w = min_w
		@max_w = max_w
		@min_x = min_x
		@max_x = max_x
		@min_y = min_y
		@max_y = max_y
		@min_z = min_z
		@max_z = max_z

		nil
	end

	def new_status w, x, y, z
		active_neighbors = count_active_neighbors w, x, y, z
		active = active? w, x, y, z
		if active && ![2, 3].include?(active_neighbors)
			INACTIVE
		elsif !active && active_neighbors == 3
			ACTIVE
		else
			active ? ACTIVE : INACTIVE
		end
	end

	def count_active_neighbors w, x, y, z
		Grid4D.neighbors(w, x, y, z).count do |nw, nx, ny, nz|
			active? nw, nx, ny, nz
		end
	end

	def count_active
		cubes.values.map(&:values).flatten.map(&:values).flatten.map(&:values).flatten.count ACTIVE
	end

	def self.neighbors w, x, y, z
		neighborhood = []
		(z - 1).upto(z + 1) do |nz|
			(y - 1).upto(y + 1) do |ny|
				(x - 1).upto(x + 1) do |nx|
					(w - 1).upto(w + 1) do |nw|
						neighborhood << [nw, nx, ny, nz] unless  nw == w && nx == x && ny == y && nz == z
					end
				end
			end
		end
		neighborhood
	end
end
