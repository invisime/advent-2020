class Field

	attr_accessor :index
	attr_reader :name, :low_low, :low_high, :high_low, :high_high

	def initialize line
		@name, *thresholds = /([\w\s]+)\: (\d+)-(\d+) or (\d+)-(\d+)/.match(line).captures
		@low_low, @low_high, @high_low, @high_high = thresholds.map(&:to_i)
	end

	def valid? value
		(@low_low <= value && value <= @low_high) ||
			(@high_low <= value && value <= @high_high)
	end
end
