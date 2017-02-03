require 'net/http'

class IBGE
	def test_connection()
		response = Net::HTTP.get('http://api.sidra.ibge.gov.br/values/t/1612/n1/1')
		
		puts response

		if response.to_s == '' then
			return false
		else
			return true
		end
	end
end
