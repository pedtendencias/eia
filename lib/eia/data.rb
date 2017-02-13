class DataIBGE
	def initialize(date, variable, location, product, unit, value, periodicity)
		@date = standardize_date(date, periodicity)
		@variable = variable
		@location = location
		@product = product
		@unit = unit
		@value = value

		#The standard is:
		# 4 : "Trimestral Móvel"
		# 5 : "Ano"
		@periodicity = periodicity 
	end

	def standardize_date(date, periodicity)
		#date is a four digit number
		if periodicity == 6 then
			return "01/01/#{date}"
		elsif periodicity == 5 then
			y = date[0..3]
			m = date[4..5]

			return "01/#{m}/#{y}"
		else
			puts "\nError parsing date for DataIBGE. Attempted to parse #{date}.\n"
			return "ERROR"
		end
	end

	def date
		return @date
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
		if @date == '' or @date == "ERROR" or @date == nil then
			puts "Date found is invalid. Value is '#{@date}'."
			return false
		end
		
		if @variable == '' or @variable == nil then
			puts "Variable found is invalid. Value is '#{@variable}'."
			return false
		end
	
		if @location == '' or @location == nil then
			puts "Location found is invalid. Value is '#{@location}'."
			return false
		end

		if @unit == '' or @unit == nil then
			puts "Unit found is invalid. Value is '#{@unit}'."
			return false
		end

		if @value == '' or @value == nil then
			puts "Value found is invalid. Value is '#{@value}'."
			return false
		end

		return true 
	end
end
