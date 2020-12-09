#! /usr/bin/env ruby

require 'pry'
require './game_console'

# input_file = "example.txt"
input_file = "input.txt"

console = GameConsole.from input_file

# Part 1
console.run
puts console.accumulator

# Part 2

console.repair
console.run
puts console.accumulator
