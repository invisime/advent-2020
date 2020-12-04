#! /usr/bin/env ruby

class CredentialRule
	def initialize rule_definition, verbose
		@name, @predicate = rule_definition
		@verbose = verbose
	end

	def satisfied_by? credential
		return true if @predicate.call(credential)
		puts "#{@name}_valid? of #{credential.pid} failed" if @verbose
		false
	end

	def self.configure rules, verbose=false
		rules.map{|definition| CredentialRule.new definition, verbose }
	end

	def self.year_within? field, range
		->(cred) do
			year = cred.send(field)
			year.length == 4 && range.include?(year.to_i)
		end
	end

	def self.height_within? field, in_range, cm_range
		->(cred) do
			raw = cred.send(field)
			units = raw[-2..-1]
			h = raw[0..-3].to_i
			valid = case units
			when "cm"
				cm_range.include? h
			when "in"
				in_range.include? h
			else
				false
			end
		end
	end

	def self.is_rgb_color? field
		->(cred) { /^\#[0-9a-f]{6}$/ =~ cred.send(field) }
	end

	def self.included_in? field, valid_values
		->(cred) { valid_values.include? cred.send(field) }
	end

	def self.is_valid_passport_id? field
		->(cred) { /^\d{9}$/ =~ cred.send(field) }
	end
end

class Credential

	REQUIRED_KEYS = %w(byr iyr eyr hgt hcl ecl pid).map(&:to_sym)

	VALID_EYE_COLORS = %w(amb blu brn gry grn hzl oth)

	VALIDATIONS = CredentialRule.configure [
			[:birth_year, CredentialRule.year_within?(:byr, 1920..2002)],
			[:issue_year, CredentialRule.year_within?(:iyr, 2010..2020)],
			[:expiration_year, CredentialRule.year_within?(:eyr, 2020..2030)],
			[:height, CredentialRule.height_within?(:hgt, 59..76, 150..193)],
			[:hair_color, CredentialRule.is_rgb_color?(:hcl)],
			[:eye_color, CredentialRule.included_in?(:ecl, VALID_EYE_COLORS)],
			[:passport_id, CredentialRule.is_valid_passport_id?(:pid)]
	]

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
puts "#{records.count(&:required_fields_present?)} records with all fields"

