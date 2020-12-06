#! /usr/bin/env ruby

require 'pry'

class Group
	attr_reader :unique_answers, :unanimous_answers, :answers_by_person

	VALID_ANSWERS = ('a'..'z')

	def initialize answers
		@unique_answers = answers.chars.select {|c| VALID_ANSWERS.include? c } .uniq
		@answers_by_person = answers.split("\n").map(&:chars)
		@unanimous_answers = answers_by_person.reduce(&:&)
	end
end

# input_file = "example.txt"
input_file = "input.txt"

groups = File.read(input_file).split("\n\n").map {|group| Group.new group}

# Part 1
puts groups.map(&:unique_answers).map(&:count).sum

# Part 2
puts groups.map(&:unanimous_answers).map(&:count).sum
