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
example_answers_1 = [71, 51, 26, 437, 12240, 13632]
example_answers_2 = [231, 51, 46, 1445, 669060, 23340]

$parens_regexp = /\(([\d\+\*\s]+)\)/
$addition_regexp = /\d+ \+ \d+/

def do_math problem, part=1, verbose=false
	work = problem.clone
	puts problem if verbose
	while $parens_regexp.match? work do
		$parens_regexp.match work do |match_data|
			parenthetical, subexpression = match_data.to_a
			work.sub! parenthetical, do_math(subexpression, part).to_s
			puts work if verbose
		end
	end

	if part == 2
		while $addition_regexp.match? work do
			$addition_regexp.match work do |match_data|
				work.sub! match_data[0], eval(match_data[0]).to_s
				puts work if verbose
			end
		end
	end

	evaluate_left_to_right work.split ' '
end

def evaluate_left_to_right expression, running_total=0, operator='+'
	return running_total if operator.nil?
	next_total = running_total.send(operator, expression.first.to_i)
	evaluate_left_to_right expression[2..-1], next_total, expression[1]
end

# problems = examples
problems = File.readlines('input.txt', chomp: true)

# Part 1
answers_1 = problems.map {|problem| do_math problem}
puts answers_1.sum

# Part 2
answers_2 = problems.map {|problem| do_math problem, 2}
puts answers_2.sum
