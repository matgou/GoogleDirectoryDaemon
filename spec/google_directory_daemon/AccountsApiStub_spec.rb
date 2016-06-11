require 'spec_helper'

describe AccountsApiStub do

  before :all do
    @stubs = AccountsApiStub.new
  end

  describe "#getData" do
    it "return contrusctor input data whatever input arguments" do
        account_api_stub = AccountsApiStub.new("Mathieu", "Goulin")
        data=account_api_stub.getData(5)
        expect(data).to include("firstname")
        data=account_api_stub.getData(6)
        expect(data['firstname']).to match("Mathieu")
    end
  end
end

