class DataIBGE
	def initialize(year, variable, location, product, unit, value)
		@year = standardize_year(year)
		@variable = variable
		@location = location
		@product = product
		@unit = unit
		@value = value
	end

	def standardize_year(year)
		#year is a four digit number
		if year.length == 4 then
			return "01/01/#{year}"

		#date is in teh form AAAAMM or AAAATT still needs a form to differ both forms
		elsif year.length == 6 then
			y = year[0..3]
			m = year[4..5]

			return "01/#{m}/#{y}"
		else
			puts "\nError parsing date for DataIBGE. Attempted to parse #{year}.\n"
			return "ERROR"
		end
	end

	def year
		return @year
	end

	def variable
		return @variable
	end

	def location
		return @location
	end
	
	def product
		return @product
	end

	def unit
		return @unit
	end
	
	def value
		return @value.to_f
	end

	def is_valid?
		return @year != '' and @year != "ERROR" and @year != nil and
					 @variable != '' and @variable != nil and
					 @location != '' and @location != nil and
					 @product != '' and @product != nil and
					 @unit != '' and @unit != nil and
					 @value != '' and @value != nil
	end
end
