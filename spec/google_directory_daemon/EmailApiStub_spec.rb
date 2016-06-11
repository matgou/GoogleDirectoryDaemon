require 'spec_helper'

describe EmailApiStub do

  before :all do
    @stubs = EmailApiStub.new
  end

  describe "#getMainEmail" do
    it "return contrusctor input data whatever input arguments" do
        email_api_stub = EmailApiStub.new("foo_bar@poubs.org")
        data=email_api_stub.getMainEmail(5)
        expect(data).to match("foo_bar@poubs.org")
    end
  end
end

