#! /usr/bin/env ruby

require 'pry'
require './grid3d'

# input_file = "example.txt"
input_file = "input.txt"

initial_slice = File.readlines(input_file).map(&:strip).map(&:chars)
grid = Grid3D.new initial_slice

# Part 1

6.times { grid.tick }
puts grid.count_active

# Part 2
