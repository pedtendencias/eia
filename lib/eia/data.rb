class DataIBGE
	def initialize(table_code, date, variable, location, classification, unit, value, periodicity)
		@table_code = table_code
		@date = standardize_date(date, periodicity)
		@variable = variable
		@location = location

		#is an array
		@classification = classification

		@unit = unit
		@value = value

		#The standard is:
		# 2 : "Mês"
		# 4 : "Trimestral Móvel"
		# 5 : "Ano"
		@periodicity = periodicity 
	end

	def standardize_date(date, periodicity)
		#date is a four digit number
		if periodicity == 5 then
			return "01/01/#{date}"
		elsif periodicity == 4 or periodicity == 2 then
			y = date[0..3]
			m = date[4..5]

			return "01/#{m}/#{y}"		
		else
			puts "\nError parsing date for DataIBGE. Attempted to parse #{date}.\n"
			return "ERROR"
		end
	end

	def table_code
		return @table_code
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
	
	def classification
		return @classification
	end

	def unit
		return @unit
	end
	
	def value
		return @value.to_f
	end

	def periodicity
		return @periodicity
	end

	def is_valid?
		if @table_code == '' or @table_code == nil or @table_code.to_i <= 0 then
			puts "Invalid table code supplied. Value is #{@table_code}."
			return false
		end

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

		if @periodicity == nil or @periodicity.to_i > 5 or @periodicity.to_i < 0 then
			puts "Periodicity is invalid. Value is '#{@periodicity}'."
			return false
		end

		if @value == '' or @value == nil then
			puts "Value found is invalid. Value is '#{@value}'."
			return false
		end

		if @classification == nil or not @classification.class.to_s.eql? "Array" then
			puts "Classification is invalid. Value is nil."
			return false
		end

		return true 
	end
end
