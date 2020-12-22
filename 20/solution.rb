#! /usr/bin/env ruby

require 'pry'
require './tile'
require './puzzle'
require './image'

# input_file = "example.txt"
input_file = "input.txt"

tiles = File.read(input_file).split("\n\n").map {|chunk| Tile.new chunk}

# Part 1

puts tiles.select(&:corner?).map(&:id).reduce(&:*)

# Part 2

puzzle = Puzzle.new tiles
puzzle.solve!

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

image = Image.new puzzle
image.scan_for SEA_MONSTERS

puts image.roughness
