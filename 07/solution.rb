#! /usr/bin/env ruby

require 'pry'

class Bag
	attr_reader :color, :contents

	@@bags_by_color = {}

	def initialize description
		@color, other_bags = description.split(" bags contain ").map(&:strip)
		@contents = other_bags.scan(/(\d+) (\w+ \w+) bag[s]?[\,\.]/).map {|contents| Contents.new contents}
		@allowed_colors = @contents.map(&:color)
		@@bags_by_color[color] = self
	end

	def include? color
		@allowed_colors.include? color
	end

	def parents
		@parents ||= @@bags_by_color.values.select {|bag| bag.include? color}
	end

	def ancestor_colors
		@ancestor_colors ||= parents.map(&:color) | (parents.map(&:ancestor_colors).reduce(&:|) || [])
	end

	def nested_bag_count count_me=0
		@contents.inject(count_me) do |total, c|
			total + Bag.of_color(c.color).nested_bag_count(1) * c.count
		end
	end

	def self.of_color color
		@@bags_by_color[color]
	end
end

class Contents
	attr_accessor :count, :color

	def initialize description
		count_string, @color = description
		@count = count_string.to_i
		@all_contents = {}
		@all_contents[color] = description
	end
end

# input_file = "example1.txt"
input_file = "example2.txt"
input_file = "input.txt"

bags = File.read(input_file).split("\n").map {|description| Bag.new description}

# Part 1

gold_bag = Bag.of_color "shiny gold"
puts gold_bag.ancestor_colors.count

# Part 2
puts gold_bag.nested_bag_count
