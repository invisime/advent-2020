require './tile.rb'

class Image < Tile

	attr_reader :sea_monsters

	def initialize puzzle
		@rows_of_pixels = puzzle.borderless_tile_visualization(false).split "\n"
		@monster_pixels = []
	end

	def scan_for sea_monsters
		@sea_monsters = {}
		sea_monsters.each do |monster|
			@rows_of_pixels.each.with_index do |row, r|
				@sea_monsters[monster] ||= []
				row.length.times do |c|
					if monster_at? monster, r, c
						@sea_monsters[monster] << [r, c]
					end
				end
			end
		end
	end

	def monster_at? monster, r, c
		mask = Image.monster_mask monster
		matching_pixels = mask.select do |mr, mc|
			!!@rows_of_pixels[r + mr] &&
			@rows_of_pixels[r + mr][c + mc] == '#'
		end
		mask.count == matching_pixels.count
	end

	def visualization clarify_water=true, enhance_monsters=false
		display = @rows_of_pixels.join "\n"
		display.gsub! '.', ' ' if clarify_water
		display.gsub! '#', '.' if clarify_water
		raise "I was too lazy to do this yet." if enhance_monsters
		display
	end

	def darkness
		@rows_of_pixels.flatten.join.count '#'
	end

	def roughness
		monster_pixels = @sea_monsters.select{|k,v| v.any?}.map{|k,v| k.join.count('#') * v.count }.sum
		darkness - monster_pixels
	end

	@@masks_by_monster = {}

	def self.monster_mask monster
		return @@masks_by_monster[monster] if @@masks_by_monster.include? monster
		mask = []
		monster.each_index do |r|
			monster[r].chars.each.with_index do |pixel, c|
				mask << [r, c] if pixel == '#'
			end
		end
		@@masks_by_monster[monster] = mask
	end
end
