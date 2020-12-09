#! /usr/bin/env ruby

class GameConsole

	attr_reader :accumulator, :next_line, :stopped

	def initialize instructions
		@program = instructions
		reset
	end

	def reset
		@accumulator = 0
		@next_line = 0
		@execution_log = []
		@stopped = false
	end

	def clone_program
		@program.clone
	end

	def self.from input_file
		parse = ->(line, number) { Instruction.new line.strip, number }
		boot_code = File.readlines(input_file).map.with_index &parse
		GameConsole.new boot_code
	end

	def next_instruction
		@program[@next_line]
	end

	def print_status
		line_readouts = @program.map {|i| "#{i.line_number.to_s}#{i.line_number == @next_line ? '>' : ':' }\t #{i}" }
		status = @stopped ? "Stopped" : "Running"
		puts "#{status}\naccumulator: #@accumulator\n\n" + line_readouts.join("\n")
	end

	def run
		tick until @stopped
		@accumulator
	end

	def tick
		valid_lines = (0..@program.count - 1)
		if @execution_log.include?(@next_line) || !valid_lines.include?(@next_line)
			@stopped = true
			return @accumulator
		end
		@execution_log << @next_line
		next_instruction.execute self
		@accumulator
	end

	def success?
		@stopped && @next_line == @program.count
	end

	def acc arg
		@accumulator += arg
		@next_line += 1
	end

	def jmp arg
		@next_line += arg
	end

	def nop arg
		@next_line += 1
	end

	def repair
		@program.each do |instruction|
			next if instruction.operation == "acc"
			test_program = clone_program
			test_program[instruction.line_number] = instruction.flip
			test_console = GameConsole.new test_program
			test_console.run
			if test_console.success?
				@program = test_program
				reset
				return true
			end
		end
		return false
	end
end

class Instruction

	attr_reader :line_number, :operation, :arg, :to_s

	VALID_OPS = %w(acc jmp nop)

	def initialize line, number
		@to_s, @line_number = line, number
		@operation, str_arg = line.split(/\s/)
		raise "Unrecognized operation #@operation" unless VALID_OPS.include? @operation
		@arg = str_arg.to_i
	end

	def execute runtime
		runtime.send(operation, arg)
	end

	def flip
		line = case operation
		when "acc"
			to_s
		when "jmp"
			"nop #@arg"
		when "nop"
			"jmp #@arg"
		end
		Instruction.new line, line_number
	end
end
