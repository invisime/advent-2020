class Ticket

	attr_reader :values, :invalid_values

	def initialize line
		@values = line.split(',').map(&:to_i)
		validate if @@fields
	end

	def validate
		@invalid_values = values.select{|value| !@@fields.any?{|field| field.valid? value}}
	end

	def possibly_valid?
		!@invalid_values.any?
	end

	def self.fields
		@@fields
	end

	def self.fields= fields
		@@fields = fields
	end

	@@fields = nil
end
