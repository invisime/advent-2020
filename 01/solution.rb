#! /usr/bin/env ruby
def find_match(list, sum)
    list.each do |expense|
        matching_expense = sum - expense
        return expense, matching_expense if list.include? matching_expense
    end
    return :no_match
end

def find_matches(list, sum)
    list.each_with_index do |expense, i|
        possible_match = find_match(list.drop(i + 1), sum - expense)
        next if possible_match == :no_match
        return [expense] + possible_match
    end
end


# expenses = [1721,979,366,299,675,1456]
expenses = File.readlines("input.txt").map(&:to_i)

# Part 1
# matching_expenses = find_match(expenses, 2020)
# raise "No match found." if matching_expenses == :no_match
# puts matching_expenses.inject(&:*)

# Part 2
matching_expenses = find_matches(expenses, 2020)

puts matching_expenses.inject(&:*)
