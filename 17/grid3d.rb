class Grid3D
	ACTIVE = '#'
	INACTIVE = '.'

	def initialize origin_layer
		@history = [{0 => {}}]
		@min_z = 0
		@max_z = 0
		@min_y = 0
		@min_x = 0
		origin_layer.each.with_index do |row, y|
			cubes[0][y] = {}
			@max_y = y
			row.each.with_index do |status, x|
				cubes[0][y][x] = status
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

	def active? x, y, z
		cubes.include?(z) && cubes[z].include?(y) && cubes[z][y][x] == ACTIVE
	end

	def visualization
		@min_z.upto(@max_z).map do |z|
			"z=#{z}\n" + @min_y.upto(@max_y).map do |y|
				@min_x.upto(@max_x).map do |x|
					cubes[z][y][x]
				end.join
			end.join("\n")
		end.join("\n\n")
	end

	def tick
		new_cubes = {}
		min_x = @max_x
		min_y = @max_y
		min_z = @max_z
		max_x = @min_x
		max_y = @min_y
		max_z = @min_z

		(@min_z - 1).upto(@max_z + 1).each do |z|
			new_cubes[z] = {}
			(@min_y - 1).upto(@max_y + 1).each do |y|
				new_cubes[z][y] = {}
				(@min_x - 1).upto(@max_x + 1).each do |x|
					old_status = active? x, y, z
					new_cubes[z][y][x] = status = new_status x, y, z
					if status == ACTIVE
						# puts [x, y, z].join(', ') + " active."
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

		@history << new_cubes
		@min_x = min_x
		@max_x = max_x
		@min_y = min_y
		@max_y = max_y
		@min_z = min_z
		@max_z = max_z

		nil
	end

	def new_status x, y, z
		active_neighbors = count_active_neighbors x, y, z
		active = active? x, y, z
		if active && ![2, 3].include?(active_neighbors)
			INACTIVE
		elsif !active && active_neighbors == 3
			ACTIVE
		else
			active ? ACTIVE : INACTIVE
		end
	end

	def count_active_neighbors x, y, z
		Grid3D.neighbors(x, y, z).count do |nx, ny, nz|
			active? nx, ny, nz
		end
	end

	def count_active
		cubes.values.map(&:values).flatten.map(&:values).flatten.count ACTIVE
	end

	def self.neighbors x, y, z
		neighborhood = []
		(z - 1).upto(z + 1) do |nz|
			(y - 1).upto(y + 1) do |ny|
				(x - 1).upto(x + 1) do |nx|
					neighborhood << [nx, ny, nz] unless nx == x && ny == y && nz == z
				end
			end
		end
		neighborhood
	end
end
