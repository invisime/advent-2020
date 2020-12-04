#! /usr/bin/env ruby

require 'pry'

class Credential

	REQUIRED_KEYS = %w(byr iyr eyr hgt hcl ecl pid).map(&:to_sym)

	DIGITS = "0".upto("9").to_a.join
	HEX_CHARACTERS = DIGITS + "a".upto("h").to_a.join
	VALID_EYE_COLORS = %w(amb blu brn gry grn hzl oth)

	VALIDATIONS = %w(
			birth_year_valid?
			issue_year_valid?
			expiration_year_valid?
			height_valid?
			hair_color_valid?
			eye_color_valid?
			passport_id_valid?
	).map(&:to_sym)

	def initialize raw
		@kvps = raw.split(/\s+/).map do |kvp|
			parts = kvp.split(":")
			[parts[0].to_sym, parts[1]]
		end.to_h
	end

	def method_missing method_id
		if REQUIRED_KEYS.include? method_id
			return @kvps[method_id]
		elsif
			super
		end
	end

	def valid?
		required_fields_present? && VALIDATIONS.all? {|validation| self.send(validation)}
	end

	def required_fields_present?
		(REQUIRED_KEYS - @kvps.keys).empty?
	end

	def birth_year_valid?
		year_valid? byr, 1920, 2002
	end

	def issue_year_valid?
		year_valid? iyr, 2010, 2020
	end

	def expiration_year_valid?
		year_valid? eyr, 2020, 2030
	end

	def year_valid? year, min, max
		y = year.to_i
		min <= y && y <= max
	end

	def height_valid?
		h = hgt.to_i
		if hgt.include? "in"
			return 59 <= h && h <= 76
		elsif hgt.include? "cm"
			return 150 <= h && h <= 193
		end
		false
	end

	def hair_color_valid?
		return false unless hcl[0] == "#"
		hcl[1..-1].chars.all? {|char| HEX_CHARACTERS.include? char}
	end

	def eye_color_valid?
		VALID_EYE_COLORS.include? ecl
	end

	def passport_id_valid?
		return false unless pid.length === 9
		pid.chars.all? {|digit| DIGITS.include? digit}
	end
end

#input_file = "example.txt"
input_file = "input.txt"

records = File.read(input_file).split("\n\n")
	.map{|record| Credential.new record}

#Part 1
puts records.count(&:required_fields_present?)

#Part 2
puts records.count(&:valid?)

