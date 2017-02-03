require "spec_helper"

RSpec.describe Eia do
  it "has a version number" do
    expect(Eia::VERSION).not_to be nil
  end
  
  before :all do
	@eia = IBGE.new
  end

  it "I try to connect to IBGE" do
    expect(@eia.test_connection).to eq(true)
  end
end
