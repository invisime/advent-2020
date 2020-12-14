#! /usr/bin/env ruby

require 'pry'

class Decoder

	attr_accessor :part
	attr_reader :mem, :and_mask, :or_mask, :raw_mask

	def initialize
		@part = 1
		@mem = {}
	end

	def execute line
		if Decoder.mask_assignment? line
			set_new_mask line
		else
			write_raw line
		end
	end

	def self.mask_assignment?	line
		line.match(/mask = /)
	end

	def set_new_mask mask_line
		@raw_mask = mask_line.split(' = ')[1]
		@mem_bits = raw_mask.length
		@and_mask = raw_mask.gsub('X', '1').to_i(2)
		@or_mask = raw_mask.gsub('X', '0').to_i(2)
	end

	def write_raw line
		to, value = /mem\[(\d+)\] = (\d+)/.match(line).captures.map(&:to_i)
		send("write_part_#@part", value, to)
	end

	def write_part_1 value, to
		masked_value = value & and_mask | or_mask
		@mem[to] = masked_value
	end

	def write_part_2 value, to
		floating_bits = @raw_mask.count('X')
		total_writes = 2**floating_bits
		masked_to = sprintf "%0#{@mem_bits}d", (to | or_mask).to_s(2)
		if total_writes == 1
			masked_addresses = [masked_to]
		else
			masked_addresses = total_writes.times.map do |permutation|
				replacements = sprintf "%0#{floating_bits}d", permutation.to_s(2)
				address = masked_to.chars.map.with_index do |to_bit, bit|
					@raw_mask[bit] == 'X' ? 'X' :	to_bit
				end
				replacements.chars.each do |replacement|
					address[address.index 'X'] = replacement
				end
				address.join
			end
		end
		masked_addresses.each do |masked_address|
			@mem[masked_address] = value
		end
	end
end

# input_file = "example1.txt"
# input_file = "example2.txt"
input_file = "input.txt"
commands = File.readlines(input_file).map(&:strip)

# Parts 1 & 2
[1,2].each do |part|
	decoder = Decoder.new
	decoder.part = part
	commands.each {|line| decoder.execute line}
	puts decoder.mem.values.sum
end
