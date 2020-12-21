#! /usr/bin/env ruby

require 'pry'

# input_file = "example.txt"
input_file = "input.txt"

dishes = File.readlines(input_file, chomp: true)

# Part 1
food_counts = Hash.new { 0 }
foods_by_alergen = Hash.new

dishes.each do |dish|
	foods, alergens = dish[0..-2].split ' (contains '

	foods = foods.split /\s/
	alergens = alergens.split ', '

	foods.each { |food| food_counts[food] += 1 }

	alergens.each do |alergen|
		if foods_by_alergen.include? alergen
			foods_by_alergen[alergen] &= foods
		else
			foods_by_alergen[alergen] = foods
		end
	end
end

allergy_free_foods = food_counts.keys - foods_by_alergen.values.flatten

puts allergy_free_foods.map{|food| food_counts[food]}.sum

binding.pry


# Part 2
