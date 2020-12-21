#! /usr/bin/env ruby

require 'pry'

# input_file = "example.txt"
input_file = "input.txt"

dishes = File.readlines(input_file, chomp: true)

# Part 1
food_counts = Hash.new { 0 }
foods_by_allergen = Hash.new

dishes.each do |dish|
	foods, allergens = dish[0..-2].split ' (contains '

	foods = foods.split /\s/
	allergens = allergens.split ', '

	foods.each { |food| food_counts[food] += 1 }

	allergens.each do |allergen|
		if foods_by_allergen.include? allergen
			foods_by_allergen[allergen] &= foods
		else
			foods_by_allergen[allergen] = foods
		end
	end
end

all_foods = food_counts.keys
all_allergens = foods_by_allergen.keys

allergy_free_foods = all_foods - foods_by_allergen.values.flatten

puts allergy_free_foods.map{|food| food_counts[food]}.sum

# Part 2

unkown_dangerous_foods = all_foods - allergy_free_foods
dangerous_food_by_allergen = {}

until unkown_dangerous_foods.empty?
	foods_by_allergen.each do |allergen, foods|
		candidate_foods = foods - dangerous_food_by_allergen.values
		next unless candidate_foods.count == 1
		dangerous_food_by_allergen[allergen] = candidate_foods[0]
		unkown_dangerous_foods.delete candidate_foods[0]
	end
end


cannonical_dangerous_food_list = dangerous_food_by_allergen.to_a.sort {|a,b| a[0] <=> b[0]}.map{|kvp| kvp[1]}.join ','

puts cannonical_dangerous_food_list
