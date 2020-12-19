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
		Rule[@id] = self
	end

	def matches? message
		return false if message.empty?
		case type
		when :a
			message == 'a'
		when :b
			message == 'b'
		when :concat
			Rule.matches_by_concatenation? message, definition
		when :or
			definition.split('|').any? { |side| Rule.matches_by_concatenation? message, side }
		end
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
end

# input_file = "example.txt"
input_file = "input.txt"

rules, messages = File.read(input_file).split("\n\n").map{|chunk| chunk.split("\n")}
rules.map! {|r| Rule.new r}

#Part 1

puts messages.count{|message| Rule["0"].matches? message}

binding.pry
