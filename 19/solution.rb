#! /usr/bin/env ruby

require 'pry'

class Rule

	@@by_id = {}

	attr_reader :id, :type, :definition

	def initialize rule
		@id, @definition = rule.split(': ')

		if @definition.include? 'a'
			@type = :a
		elsif @definition.include? 'b'
			@type = :b
		elsif @definition.include? '|'
			@type = :or
		else
			@type = :concat
		end

		@known_messages = {}
		Rule[@id] = self
	end

	def matches? message
		return @known_messages[message] if @known_messages.include? message
		return false if message.empty?
		match = case type
		when :a
			message == 'a'
		when :b
			message == 'b'
		when :concat
			Rule.matches_by_concatenation? message, definition
		when :or
			definition.split('|').any? { |side| Rule.matches_by_concatenation? message, side }
		end
		@known_messages[message] = match
	end

	def reset_known_messages
		@known_messages = {}
	end

	def n_matches? message
		j = 0
		repetitions = 0
		message.length.times do |i|
			if matches? message[j..i]
				repetitions += 1
				j = i + 1
			end
		end
		return nil unless j == message.length
		repetitions
	end

	def self.reset_all_known_messages
		@@by_id.values.each(&:reset_known_messages)
	end

	def self.matches_by_concatenation? message, rules
		unsatisfied_subrules = rules.strip.split(/\s/).map{ |id| Rule[id] }
			j = 0
			message.length.times do |i|
				return false if unsatisfied_subrules.empty?
				binding.pry if unsatisfied_subrules.first.nil?
				if unsatisfied_subrules.first.matches? message[j..i]
					unsatisfied_subrules.shift
					j = i + 1
				end
			end
			unsatisfied_subrules.empty?
	end

	def self.[]= id, r
		@@by_id[id] = r
	end

	def self.[] id
		@@by_id[id]
	end

	def self.zero_matches? message
		Rule["0"].matches? message
	end

	def self.zero_matches_part_2? message
		# via the new rules 8 and 11 (used only in rule 0) the new rule 0 specifies:
		#		rule 0 = rule 42 twice or more followed by rule 31 once or more, but
		#		there must be more 42s than 31s

		1.upto(message.length) do |i|
			lhs = message[0..-i-1]
			rhs = message[-i..-1]
			left_matches = Rule["42"].n_matches? lhs
			next unless left_matches
			right_matches = Rule["31"].n_matches? rhs
			next unless right_matches
			return true if left_matches > right_matches
		end
		false
	end
end

# input_file = "example2.txt"
input_file = "input.txt"

rules, messages = File.read(input_file).split("\n\n").map{|chunk| chunk.split("\n")}
rules.each {|r| Rule.new r}

# Part 1

puts messages.count{|message| Rule.zero_matches? message}

# Part 2
Rule.reset_all_known_messages

puts messages.count{|message| Rule.zero_matches_part_2? message}
