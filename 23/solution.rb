#! /usr/bin/env ruby

require 'pry'

class CupRing
	def initialize cup_array
		@size = cup_array.length
		cups = cup_array.map {|cup_label| [cup_label,[]]}
		cups.each.with_index {|cup, i| cups[i - 1][1] = cup}
		@cups_by_label = cups.to_h {|cup| [cup[0], cup] }
		@current_cup = cups[0]
		@moves = 0
	end

	def to_a
		a = [@current_cup]
		(@size - 1).times { a << a[-1][1] }
		a.map(&:first)
	end

	def tick!
		@moves += 1
		puts	"-- move #@moves --", "cups: #{to_a.join ' '}" if $verbose

		picked_up_cups = @current_cup[1], @current_cup[1][1], @current_cup[1][1][1]
		@current_cup[1] = picked_up_cups.last[1]

		missing_cup_labels = [@current_cup, *picked_up_cups].map(&:first)
		destination = @current_cup.first
		destination = (destination + @size - 2) % @size + 1 while missing_cup_labels.include? destination
		destination_cup = @cups_by_label[destination]

		puts	"pick up: #{picked_up_cups.map(&:first).join ', '}", "destination: #{destination}" if $verbose

		picked_up_cups.last[1] = destination_cup[1]
		destination_cup[1] = picked_up_cups.first
		@current_cup = @current_cup[1]
		nil
	end

	def part_1_solution
		cups = to_a
		cups.rotate! until cups[0] == 1
		cups[1..-1].join
	end

	def part_2_solution
		@cups_by_label[1][1][0] * @cups_by_label[1][1][1][0]
	end
end

example_input = "389125467"
real_input = "538914762"
input = real_input

# Part 1

ring = CupRing.new input.chars.map(&:to_i)
100.times { ring.tick! }

puts ring.part_1_solution

# Part 2

more = input.chars.map(&:to_i) + 10.upto(10**6).to_a
ring = CupRing.new more
(10**7).times { ring.tick! }

puts ring.part_2_solution
