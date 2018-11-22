require 'net/http'
require 'json'
require_relative 'data'

class IBGE
	def initialize()
			@webservice_url = 'http://api.sidra.ibge.gov.br' 
	end

	def connected?()
	  response = Net::HTTP.get(URI(@webservice_url + '/values/t/1612/n1/1'))

	  if response.to_s == '' then
	    return false
	  else
	    return true
	  end
	end

	# What is expected:
	# code : a single primary key which corresponds to category of series in IBGE's system;
	# period : a string with any acceptable set of parameters
	# variables : a list of acceptable variables the the series
	# territorial_leve : a string in the form n_lvl+0|territories_0;n_lvl_1|territories_1;...
  #										 where n_lvl_k is a number from 1 to 6 and territories_i is a valid
	#										 string form specifying terriories
	# classification : a string in the form c_lvl_k | list_of_products; c_lvl_j | list_of_products; ...
	def get_series(code, period, variables, territorial_level, classification)
		url = @webservice_url + "/values"

		if code != '' and code != nil then
			url += "/t/#{code}"
		end

		if period != '' and period != nil then
			url += "/p/#{period}"
		else
			url += "/p/all"
		end

		if variables != '' and variables != nil then
			url += "/v/#{variables}"
		else
			url += "/v/all"
		end

		if territorial_level != '' and territorial_level != nil then
			territorial_level.split(';').each do |word|
				ws = word.split('|')
				url += "/n#{ws[0]}/#{ws[1]}"	
			end
		else
			url += "/n1/all"
		end
		
		if classification != '' and classification != nil then
			classification.split(';').each do |word|
				ws = word.split('|')
				url += "/c#{ws[0]}/#{ws[1]}"
			end
		end
	
		return consume_json(Net::HTTP.get(URI(url)), code)
	end

	def consume_json(json_string, table_code)
		begin
			output = JSON.parse(json_string)
			heading = output.delete_at(0)
			identifier = heading["D1N"]

			if identifier.include? "Trimestre Móvel" then 
				periodicity = 6
			elsif identifier.eql? "Trimestre" then
				periodicity = 4
			elsif identifier.include? "Ano" then
				periodicity = 5
			elsif identifier.include? "Mês" then
				periodicity = 2
			else
				puts "Error! Unexpected case! Found is: #{identifier}. Report to the dev team."
				return Array.new
			end

			data_array = Array.new

			output.each do |hash|
				data = nil
				date = nil
				variable = nil
				classification = Array.new
				location = nil
				unit = nil
				val = nil

				hash.each do |key, value|
					case key
						when "D1C" #date
							date = value
						when "D2N" #variable
							variable = value
						when "D3N" #location
							location = value
						when "MN" #unit
							unit = value
						when "V" #value
							val = value.to_f
						else
							if key.include? "D" and key.include? "N" and key[1].to_i > 3 then
								classification << "#{heading[key]}: #{value}"
							end
							#Else this information is discarded
					end
				end

				data_array << DataIBGE.new(table_code, date, variable, location, 
																	 classification, unit, val, periodicity)
			end	
			
			return data_array	
	
		rescue Exception => e
			if e.to_s.include? "incompatível com a tabela" then
				return Array.new
			else
				puts "Error parsing the JSON response: #{e}\nTrace: #{e.backtrace}"
				return nil
			end
		end
	end
end
