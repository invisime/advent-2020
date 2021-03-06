#! /usr/bin/env ruby

require 'pry'
require './grid3d'
require './grid4d'

# input_file = "example.txt"
input_file = "input.txt"

initial_slice = File.readlines(input_file).map(&:strip).map(&:chars)

# Part 1
grid = Grid3D.new initial_slice
6.times { grid.tick }
puts grid.count_active

# Part 2
grid = Grid4D.new initial_slice
6.times { grid.tick }
puts grid.count_active
