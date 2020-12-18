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

$subexpression_regex = /\(([\d\+\*\s]+)\)/

def do_math problem
	work = problem.clone
	while $subexpression_regex.match? work do
		$subexpression_regex.match work do |match_data|
			parenthetical, subexpression = match_data.to_a
			work.sub! parenthetical, do_math(subexpression).to_s
		end
	end
	evaluate_simple work.split ' '
end

def evaluate_simple expression, running_total=0, operator='+'
	return running_total if operator.nil?
	next_total = running_total.send(operator, expression.first.to_i)
	evaluate_simple expression[2..-1], next_total, expression[1]
end

# Part 1

problems = File.readlines('input.txt', chomp: true)

answers = problems.map {|problem| do_math problem}
puts answers.sum

binding.pry
