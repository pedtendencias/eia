require 'net/http'
require 'json'

class IBGE
	def initialize()
			@webservice_url = 'http://api.sidra.ibge.gov.br' 
	end

	def test_connection()
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
	# classification : a string in the form c_lvl_k | list_of_products
	def get_serie(code, period, variables, territorial_level, classification)
		url = @webservice_url + "/values"

		if code != '' then
			url += "/t/#{code}"
		end

		if period != '' then
			url += "/p/#{period}"
		else
			url += "/p/all"
		end

		if variables != '' then
			url += "/v/#{variables}"
		else
			url += "/v/all"
		end

		if territorial_level != '' then
			territorial_level.split(";").each do |word|
				ws = word.split("|")
				url += "/n#{ws[0]}/#{ws[1]}"	
			end
		else
			url += "/n1/all"
		end
		
		if classification != '' then
			ws = classification.split("|")
			url += "/c#{ws[0]}/#{ws[1]}"
		end if	

		url += "/f/n/d/m"
		
		return consume_json(Net::HTTP.get(URI(url)))
	end

	def consume_json(json_string)
		output = JSON.parse(json_string)

		heading = output.delete(0)

		output.each do |hash|
			hash.each do |key, value|
				case heading[key]
					when "Ano"
					when "Variável"
					when "Valor"
					when "Unidade de Medida"
				end
			end
		end	
	end
end
