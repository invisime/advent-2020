#! /usr/bin/env ruby

require 'pry'

examples = [
"1 + 2 * 3 + 4 * 5 + 6",
"1 + (2 * 3) + (4 * (5 + 6))",
"2 * 3 + (4 * 5)",
"5 + (8 * 3 + 9 + 3 * 4 * 3)",
"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
]
example_answers = [71, 51, 26, 437, 12240, 13632]

input = examples
# input = File.readlines(input_file)

problems = input.map {|line| line.gsub(/\s/, '').chars }


def do_math expression, running_total=0, last_operator='+', length=-1
	puts ['calculating: ', running_total.to_s, last_operator, *expression, " with length ", length].join
	return running_total if expression.nil? || expression.empty?

	skip = 0
	value = case expression.first
	when /\d/
		calculate running_total, expression.first.to_i, last_operator
	when '('
		do_math expression[1..-1]
	when ')'
		running_total
	end

	return do_math expression[(skip + 2)..-1], value, expression[skip + 1], length + 2
end

def calculate a, b, operator
	case operator
	when '+'
		a + b
	when '*'
		a * b
	else
		binding.pry
		raise "unknown operator '#{operator}'"
	end
end

# Part 1

binding.pry
