describe Strip::Error do
  it 'should have a Base error' do
    Strip::Error.constants.should include(:Base)
  end

  [:SyntaxError, :ExpectationError].each do |error|
    it "should have a #{error} which is a sublcass of Base" do
      Strip::Error.constants.should include(error)
      Strip::Error.const_get(error).should <= Strip::Error::Base
    end
  end
end
