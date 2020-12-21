#! /usr/bin/env ruby

require 'pry'
require './tile'
require './puzzle'

input_file = "example.txt"
# input_file = "input.txt"

tiles = File.read(input_file).split("\n\n").map {|chunk| Tile.new chunk}

# Part 1

puts tiles.select(&:corner?).map(&:id).reduce(&:*)

# Part 2

puzzle = Puzzle.new tiles

puzzle.solve!
