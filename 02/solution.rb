#! /usr/bin/env ruby
class PasswordEntry
    def initialize row
        policy, @password = row.split ": "
        @rule, @letter = policy.split ' '
    end

    def valid_part_1?
        min_occurence, max_occurence = @rule.split('-').map(&:to_i)
        count = @password.count @letter
        min_occurence <= count && count <= max_occurence
    end

    def valid_part_2?
        # pred is used since positions are given as 1-indexed
        first, second = @rule.split('-').map(&:to_i).map(&:pred)
        (@password[first] == @letter) ^ (@password[second] == @letter)
    end
end

input_file = "example.txt"
#input_file = "input.txt"

password_entries = File.readlines(input_file).map {|row| PasswordEntry.new row }

#puts password_entries.filter(&:valid_part_1?).count
puts password_entries.filter(&:valid_part_2?).count

