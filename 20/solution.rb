#! /usr/bin/env ruby

require 'pry'
require './tile'
require './puzzle'

# input_file = "example.txt"
input_file = "input.txt"

tiles = File.read(input_file).split("\n\n").map {|chunk| Tile.new chunk}

# Part 1

corners = tiles.select {|tile| tile.all_possible_neighbors.count == 2}
puts corners.map(&:id).reduce(&:*)

# Part 2
puts ["Good luck!", SEA_MONSTER].join("\n")

binding.pry
