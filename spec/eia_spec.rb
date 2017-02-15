require "spec_helper"

RSpec.describe Eia do
  it "has a version number" do
    expect(Eia::VERSION).not_to be nil
  end

  context "creates a valid IBGE instance" do
	  before :all do
  	  @con = IBGE.new
	  end

    it "can connect to IBGE" do
      expect(@con.connected?).to eq(true)
    end

		context "is conected to IBGE and requests a series" do
			before :all do
				@valid_series = {code: "1955", period:  "last",
												 variables: "96", territorial_level: "1|all;",
												 classification: "1|2"}

				@invalid_series = {code: "1", period: "last", variables: "all", 
													 territorial_level: "2|all;", classification: "81|2702"}
			end

			context "which is invalid" do
				before :all do
					@invalid_request = @con.get_series(@invalid_series[:code],
																						 @invalid_series[:period],
																						 @invalid_series[:variables],
																						 @invalid_series[:territorial_level],
																						 @invalid_series[:classification])
				end

				it "has no results" do
					expect(@invalid_request.length).to eq(0)
				end
			end
		
			context "which is valid" do
				before :all do
					@valid_request = @con.get_series(@valid_series[:code],
																					 @valid_series[:period],
																					 @valid_series[:variables],
																					 @valid_series[:territorial_level],
																					 @valid_series[:classification])
					@item = @valid_request[0]
				end

				it "has one or more items" do
					expect(@valid_request.length >= 1).to eq(true)
				end

				it "has no nils" do
					expect(@valid_request.include? nil).to eq(false)
				end

				it "has valid values" do
					expect(@item.is_valid?).to eq(true)
				end

				context "and has classifications" do
					it "has one or more classifications" do
						expect(@item.classification[0] != nil).to eq(true)
					end
				end
			end
  	end
	end
end
