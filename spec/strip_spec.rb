describe Strip do
  it 'should have Error base exception class' do
    Strip.constants.should include(:Error)
  end

  it "should have SytaxError exception which is a sublcass of Error" do
    Strip.constants.should include(:SyntaxError)
    Strip::SyntaxError.should <= Strip::Error
  end

  describe '#version' do
    it 'should consist of Major, Minor and Patch joined by a dot' do
      [Strip::Version::Major, Strip::Version::Minor, Strip::Version::Patch].join('.').should \
        eq(Strip.version)
    end
  end
end
