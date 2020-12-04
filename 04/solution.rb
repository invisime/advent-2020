#! /usr/bin/env ruby

require 'pry'

class CredentialRule
	def initialize rule_definition, verbose=false
		@name, @predicate = rule_definition
		@verbose = verbose
	end

	def satisfied_by? credential
		return true if @predicate.call(credential)
		puts "#{@name}_valid? of #{credential.pid} failed" if @verbose
		false
	end

	def self.year field, min, max
		return ->(cred) {
			y = cred.send(field).to_i
			min <= y && y <= max
		}
	end
end

class Credential

	REQUIRED_KEYS = %w(byr iyr eyr hgt hcl ecl pid).map(&:to_sym)

	DIGITS = "0".upto("9").to_a.join
	HEX_CHARACTERS = DIGITS + "a".upto("h").to_a.join
	VALID_EYE_COLORS = %w(amb blu brn gry grn hzl oth)

	VALIDATIONS = [
			[:birth_year, CredentialRule.year(:byr, 1920, 2002)],
			[:issue_year, CredentialRule.year(:iyr, 2010, 2020)],
			[:expiration_year, CredentialRule.year(:eyr, 2020, 2030)],
			[:height, ->(cred) {
					h = cred.hgt.to_i
					(cred.hgt.include?("in") && 59 <= h && h <= 76) ||
						(cred.hgt.include?("cm") && 150 <= h && h <= 193)
			}],
			[:hair_color, ->(cred) { cred.hcl[0] == "#" && cred.hcl[1..-1].chars.all? {|char| HEX_CHARACTERS.include? char }}],
			[:eye_color, ->(cred) { VALID_EYE_COLORS.include? cred.ecl }],
			[:passport_id, ->(cred) { cred.pid.length === 9 && cred.pid.chars.all? {|digit| DIGITS.include? digit }}],
	].map{|definition| CredentialRule.new definition }

	def initialize raw
		@kvps = raw.split(/\s+/).map do |kvp|
			parts = kvp.split(":")
			[parts[0].to_sym, parts[1]]
		end.to_h

		@kvps.keys.each do |key|
			self.class.define_method(key, -> { @kvps[key] })
		end
	end

	def valid?
		required_fields_present? && VALIDATIONS.all? {|rule| rule.satisfied_by? self}
	end

	def required_fields_present?
		(REQUIRED_KEYS - @kvps.keys).empty?
	end
end

#input_file = "example.txt"
input_file = "input.txt"

records = File.read(input_file).split("\n\n").map{|record| Credential.new record}

#Part 2
valid_count = records.count(&:valid?)
invalid_count = records.count - valid_count
puts "#{valid_count}/#{records.count} records valid (#{invalid_count} invalid)"

#Part 1
puts "#{records.count(&:required_fields_present?)} records without all fields"

