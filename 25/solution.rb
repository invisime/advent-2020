#! /usr/bin/env ruby

require 'pry'

MODULUS = 20201227

def transform subject_number, loop_size
	value = 1
	loop_size.times { value = (value * subject_number) % MODULUS }
	value
end

def brute_force_loop_size public_key
	value = 1
	loop = 0
	until value == public_key do
		value = (value * 7) % MODULUS
		loop += 1
	end
	loop
end

example_input = [5764801, 17807724]
real_input = [8184785, 5293040]

public_keys = real_input

# Part 1
card = 0
door = 1

card_loop_size = brute_force_loop_size public_keys[card]
encryption_key = transform public_keys[door], card_loop_size

puts encryption_key

# Part 2 N/A
