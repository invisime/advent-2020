#! /usr/bin/env ruby

require 'pry'
require './tile'
require './puzzle'

# input_file = "example.txt"
input_file = "input.txt"

tiles = File.read(input_file).split("\n\n").map {|chunk| Tile.new chunk}

# Part 1

puts tiles.select(&:corner?).map(&:id).reduce(&:*)

# Part 2
puts ["Good luck!", SEA_MONSTER, nil].join("\n")

puzzle = Puzzle.new tiles

puzzle.solve

binding.pry
