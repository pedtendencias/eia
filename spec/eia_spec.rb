require "spec_helper"

RSpec.describe Eia do
  it "has a version number" do
    expect(Eia::VERSION).not_to be nil
  end
  
  before :all do
    @eia = IBGE.new
  end

  context "created an valid IBGE instance" do
    it "can connect to IBGE" do
      expect(@eia.test_connection).to eq(true)
    end

		context "is conected to IBGE" do
			it "can request a valid result" do
				#faz alguma coisa
				expect(false).to eq(true)
			end
		end
  end
end
