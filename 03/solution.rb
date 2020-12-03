#! /usr/bin/env ruby

class Course
    TREE = "#"

    def initialize data
        @raw_data = data
        @height = data.length
        @width = data[0].length
    end

    def has_tree? row, column
        @raw_data[row][column % @width] == TREE
    end

    def count_trees_from row, column, down, right
        return 0 if row >= @height
        this_tree = has_tree?(row, column) ? 1 : 0
        this_tree + count_trees_from(row + down, column + right, down, right)
    end

    def run down=1, right=3
        count_trees_from 0, 0, down, right
    end
end

#input_file = "example.txt"
input_file = "input.txt"

course = Course.new File.readlines(input_file).map(&:strip)

# Part 1
# puts course.run

# Part 2
slopes = [
	[1, 1],
	[1, 3],
	[1, 5],
	[1, 7],
	[2, 1]]

trees_per_slope = slopes.map{|down, right| course.run down, right}
puts trees_per_slope.inject(&:*)

