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
												 variables: "96", territorial_level: "1|all",
												 classification: "1|2"}

				@valid_series_2 = {code: "3418", period:  "last",
												 variables: "564", territorial_level: "1|1",
												 classification: "85|90671;11046|40311"}

				@valid_trimestral_series = {code: 1620, period: "all",
																		variables: 583, territorial_level: "1|1",
																		classification: "11255|90691"}

				@invalid_series = {code: "1", period: "last", variables: "all", 
													 territorial_level: "2|all;", classification: "81|2702"}

				@trimestre_movel_series = {code: "6318", period: "all", variables: "1641", 
													 territorial_level: "1|1;", classification: "629|32386"}

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
				context "and is of trimestre movel periodicity" do
					before :all do
						@trimestral_movel_request = @con.get_series(@trimestre_movel_series[:code],
																												@trimestre_movel_series[:period],
																												@trimestre_movel_series[:variables],
																												@trimestre_movel_series[:territorial_level],
																												@trimestre_movel_series[:classification])

						index = 0

						loop do
							index = 2 + Random.rand(@trimestral_movel_request.length / 4 - 1) * 4
							break if index <= @trimestral_movel_request.length - 1
						end

						@item_0 = nil
						@item_1 = nil
						@item_2 = nil
						@obj_0 = @trimestral_movel_request[index]

						@item_0 = @trimestral_movel_request[index - 1].date
						@item_1 = @trimestral_movel_request[index].date
						@item_2 = @trimestral_movel_request[index + 1].date
						
						d, m, a = @item_0.split('/')
						@item_0 = Time.new(a, m, d)

						d, m, a = @item_1.split('/')
						@item_1 = Time.new(a, m, d)					

						d, m, a = @item_2.split('/')
						@item_2 = Time.new(a, m, d)
					end
				
					it 'is identified as Trimestre Móvel' do
						expect(@obj_0.periodicity).to eq(6)
					end

					it 'has properly spaced data' do
						expect((@item_1.year * 12 + @item_1.month) - (@item_0.year * 12 + @item_0.month)).to eq(1)	
						expect((@item_2.year * 12 + @item_2.month) - (@item_1.year * 12 + @item_1.month)).to eq(1)
						expect((@item_2.year * 12 + @item_2.month) - (@item_0.year * 12 + @item_0.month)).to eq(2)
					end
				end

				context "and is trimestral" do
					before :all do
						@trimestral_request = @con.get_series(@valid_trimestral_series[:code],
																								@valid_trimestral_series[:period],
																								@valid_trimestral_series[:variables],
																								@valid_trimestral_series[:territorial_level],
																								@valid_trimestral_series[:classification])

						index = 0

						loop do
							index = 2 + Random.rand(@trimestral_request.length / 4 - 1) * 4
							break if index <= @trimestral_request.length - 1
						end

						@item_0 = nil
						@item_1 = nil
						@item_2 = nil

						@data = @trimestral_request[index]
						@item_0 = @trimestral_request[index - 1].date
						@item_1 = @trimestral_request[index].date
						@item_2 = @trimestral_request[index + 1].date
						
						d, m, a = @item_0.split('/')
						@item_0 = Time.new(a, m, d)

						d, m, a = @item_1.split('/')
						@item_1 = Time.new(a, m, d)					

						d, m, a = @item_2.split('/')
						@item_2 = Time.new(a, m, d)
					end

					it 'has properly spaced data' do
						expect((@item_1.year * 12 + @item_1.month) - (@item_0.year * 12 + @item_0.month)).to eq(1)	
						expect((@item_2.year * 12 + @item_2.month) - (@item_1.year * 12 + @item_1.month)).to eq(1)
						expect((@item_2.year * 12 + @item_2.month) - (@item_0.year * 12 + @item_0.month)).to eq(2)
					end

					it 'has the correct periodicity' do
						expect(@data.periodicity).to eq(4)
					end
				end

				context "and queries using a single variable" do
					before :all do
						@valid_request = @con.get_series(@valid_series[:code],
																						 @valid_series[:period],
																						 @valid_series[:variables], nil, nil)
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

				context "and queries using a single classification" do
					before :all do
						@valid_request = @con.get_series(@valid_series[:code],
																						 @valid_series[:period],
																						 nil, nil, @valid_series[:classification])
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

				context "and queries using two classifications" do
					before :all do
						@valid_request = @con.get_series(@valid_series_2[:code],
																						 @valid_series_2[:period],
																						 nil, nil, @valid_series_2[:classification])
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


				context "and queries using a single territory" do
					before :all do
						@valid_request = @con.get_series(@valid_series[:code],
																						 @valid_series[:period],
																						 nil, @valid_series[:territorial_level], nil)
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

				context "and requesting using all fields" do
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
				
				context "and queries using no fields" do
					before :all do
						@valid_request = @con.get_series(@valid_series[:code],
																						 nil, nil, nil, nil)
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
end
