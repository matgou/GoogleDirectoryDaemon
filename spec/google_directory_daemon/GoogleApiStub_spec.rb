require 'spec_helper'

describe GoogleApiStub do

  before :all do
    @stubs = GoogleApiStub.new
  end

  describe "#createAccount" do
    it "save create data in data" do
        @stubs.createAccount({"firstname" => "Mathieu"})      
        expect(@stubs.data).to include("firstname")
        expect(@stubs.data["firstname"]).to match("Mathieu")
    end
  end
end

