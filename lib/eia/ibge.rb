require 'net/http'

class IBGE
	def initialize()
	end

	def test_connection()
		response = Net::HTTP.get(URI('http://api.sidra.ibge.gov.br/values/t/1612/n1/1'))

		if response.to_s == '' then
			return false
		else
			return true
		end
	end
end
